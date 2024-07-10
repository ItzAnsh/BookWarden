import Foundation
import Combine

struct EmailPassword: Codable {
    let email: String
    let password: String
}

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case noData
}

struct UserRes: Codable {
    var user: User
    var statusCode: Int
    var message: String
    var success: Bool
}

struct TokenResponse: Decodable {
    var token: String
    var role: String
}

struct AllUserResponse: Codable, Hashable {
    let _id: String
    let name: String
    let email: String
    let role: String
    let date: String
}

struct UserDetail: Codable {
    let _id: String
    let name: String
    let email: String
    let role: String
}

class UserManager: ObservableObject {
    private init() {
        //        self.accessToken = UserDefaults.standard.string(forKey: "accessToken")
    }
    static let shared = UserManager()
    
    @Published private(set) var user: User?
    
    @Published var accessToken: String = " eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY2NjE5YjA1ZTQ2ZmE2ZGJhMmFlYjBiOCIsImlhdCI6MTcxNzk5MzA3MSwiZXhwIjoxNzE4NTk3ODcxfQ.9VVBZlByZFl3aezgZZWP4qYEAJmiAYmXeCr5sUjwBA4"
    @Published var role = ""
    @Published var allUsers: [AllUserResponse] = []
    @Published var userDetail: UserDetail = UserDetail(_id: "", name: "", email: "", role: "")
    
    func loginUser(email: String, password: String, completion: @escaping (Result<UserRes, Error>) -> Void) -> TokenResponse? {
        guard let url = URL(string: "https://bookwarden-server.onrender.com/api/users/login") else {
            completion(.failure(NetworkError.invalidURL))
            return nil
        }
        
        let loginData = EmailPassword(email: email.lowercased(), password: password)
        guard let jsonData = try? JSONEncoder().encode(loginData) else {
            print("Error encoding data")
            return nil
        }
        
        var tokenResponse = TokenResponse(token: "", role: "")
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        urlRequest.httpBody = jsonData
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Status Code: \(httpResponse.statusCode)")
                if httpResponse.statusCode == 404 {
                    print("Endpoint not found: \(url)")
                }
            }
            
            if let data = data {
                do {
                    print("Response data: \(String(data: data, encoding: .utf8) ?? "")")
                    let resData = try JSONDecoder().decode(TokenResponse.self, from: data)
                    print("\(type(of: resData.token)) \(resData.token)")
                    DispatchQueue.main.async {
                        self.accessToken = resData.token
                        tokenResponse.role = resData.role
                        tokenResponse.token = resData.token
                        self.role = resData.role
                        UserDefaults.standard.set(resData.token, forKey: "authToken")
                        UserDefaults.standard.set(resData.role, forKey: "role")
                    }
                } catch {
                    print("Error decoding data: \(error)")
                }
            }
        }.resume()
        
        return tokenResponse
    }
    
    let url1 = "https://bookwarden-server.onrender.com/api/librarian/getAllUsers"
    
    func fetchAllUsers() {
            guard let url = URL(string: "https://bookwarden-server.onrender.com/api/librarian/getAllUsers") else { return }

            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                    return
                }

                if let data = data {
                    do {
                        let decodedResponse = try JSONDecoder().decode([AllUserResponse].self, from: data)
                        DispatchQueue.main.async {
                            self.allUsers = decodedResponse
                        }
                    } catch {
                        print("Error decoding response: \(error)")
                        if let dataString = String(data: data, encoding: .utf8) {
                            print("Response data: \(dataString)")
                        }
                    }
                }
            }.resume()
        }
    
    func addUser(userMail: String, completion: @escaping (Bool) -> Void) {
            guard let url = URL(string: "https://bookwarden-server.onrender.com/api/librarian/createMultipleUser") else {
                completion(false)
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let user = ["users": [["email": userMail]]]
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: user, options: [])
//                print(String(data: request, encoding: .utf8))
                guard let httpBody = request.httpBody else {
                    print("")
                    return
                }
                print(String(data: httpBody, encoding: .utf8))
            } catch {
                print("Error serializing JSON: \(error)")
                completion(false)
                return
            }

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                    completion(false)
                    return
                }

                if let httpResponse = response as? HTTPURLResponse {
                    if !(200...299).contains(httpResponse.statusCode) {
                        print("Error: HTTP status code \(httpResponse.statusCode)")
                        if let data = data, let dataString = String(data: data, encoding: .utf8) {
                            print("Response data: \(dataString)")
                        }
                        completion(false)
                        return
                    }
                }

                if let data = data {
                    do {
                        let responseData = try JSONSerialization.jsonObject(with: data, options: [])
                        print("Response: \(responseData)")
                    } catch {
                        print("Error parsing response: \(error)")
                        if let dataString = String(data: data, encoding: .utf8) {
                            print("Response data: \(dataString)")
                        }
                        completion(false)
                        return
                    }
                }

                DispatchQueue.main.async {
                    self.fetchAllUsers() // Refresh the user list
                }
                completion(true)
            }.resume()
        }
    
//    func parseUser(userDictionary: [String: Any]) -> User? {
//        guard let id = userDictionary["_id"] as? String,
//              let email = userDictionary["email"] as? String,
//              let name = userDictionary["name"] as? String,
//              let roleString = userDictionary["role"] as? String else {
//            return nil
//        }
//        let role = getRole(roleString: roleString)
//        let user = User(id: id, name: name, email: email, contactNo: "", genrePreferences: [], roles: role)
//        return user
//    }
    
    func getRole(roleString: String) -> Role {
        switch roleString {
        case "":
            return .normalUser
        case "jsgdg21672537612":
            return .librarian
        case "2543564fgfjghgfg435":
            return .admin
        default:
            return .superAdmin
        }
    }
    
    func parseUser (userDictionary : [String : Any]) -> User? {
        guard let id = userDictionary["_id"] as? String,
              let email = userDictionary["email"] as? String,
              let name = userDictionary["name"] as? String,
              var roleString = userDictionary["role"] as? String
        else {
            return nil
        }
        let role = getRole(roleString: roleString)
        let user = User(id: id, name: name, email: email, contactNo: "", genrePreferences: [], roles: role)
        return user
    }
    
    // Function to fetch user details with authorization token
    func fetchUserDetails() {
            guard let url = URL(string: "https://bookwarden-server.onrender.com/api/users/myProfile") else {
                print("Invalid URL")
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            // Add authorization token to the request header
            let token = UserDefaults.standard.string(forKey: "authToken")!
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print("Error fetching data: \(String(describing: error))")
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    if !(200...299).contains(httpResponse.statusCode) {
                        print("Error: HTTP status code \(httpResponse.statusCode)")
                        return
                    }
                }
                
                do {
                    // Decode the response
                    let responseDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    
                    if let userDetailsArray = responseDict?["UserDetails"] as? [[String: Any]] {
                        // Transform to UserDetail
                        let userDetailData = try JSONSerialization.data(withJSONObject: userDetailsArray)
                        let userDetails = try JSONDecoder().decode([UserDetail].self, from: userDetailData)
                        
                        DispatchQueue.main.async {
                            self.allUsers = userDetails.map { AllUserResponse(_id: $0._id, name: $0.name, email: $0.email, role: $0.role, date: "") }
                            self.userDetail = UserDetail(_id: userDetails[0]._id, name: userDetails[0].name, email: userDetails[0].email, role: userDetails[0].role)
                            print("User details fetched and updated: \(self.allUsers)")
                        }
                    } else {
                        print("Invalid response structure")
                    }
                } catch {
                    print("Error decoding data: \(error)")
                }
            }
            
            task.resume()
        }
    
    
}

//var userManager = UserManager.shared


// Model Extensions for Parsing from Dictionary
extension User {
    init(from dictionary: [String: Any]) throws {
        let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
        self = try JSONDecoder().decode(User.self, from: data)
    }
}

extension Issue {
    init(from dictionary: [String: Any]) throws {
        let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
        self = try JSONDecoder().decode(Issue.self, from: data)
    }
}

extension Fine {
    init(from dictionary: [String: Any]) throws {
        let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
        self = try JSONDecoder().decode(Fine.self, from: data)
    }
}

//var userManager = UserManager()

struct ResponseData {
    let userDetails: User
    let fines: [Fine]
    let issues: [Issue]
}
