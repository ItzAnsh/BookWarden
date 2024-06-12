import Foundation

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
    let password: String
    let role: String
    let date: String
}

//@AppStorage("authToken") var authToken: String = ""

class UserManager: ObservableObject {
    private init() {
        //        self.accessToken = UserDefaults.standard.string(forKey: "accessToken")
    }
    static let shared = UserManager()
    
    @Published private(set) var user: User?
    
    @Published var accessToken: String = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY2NjE5YjA1ZTQ2ZmE2ZGJhMmFlYjBiOCIsImlhdCI6MTcxNzk5MzA3MSwiZXhwIjoxNzE4NTk3ODcxfQ.9VVBZlByZFl3aezgZZWP4qYEAJmiAYmXeCr5sUjwBA4"
    @Published var role = ""
    @Published var allUsers: [AllUserResponse] = []
    
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
            }
            
            if let data = data {
                do {
                    print("Response data: \(String(data: data, encoding: .utf8) ?? "")")
                    let resData = try JSONDecoder().decode(TokenResponse.self, from: data)
                    print("\(type(of: resData.token)) \(resData.token)")
                    DispatchQueue.main.async {
                        self.accessToken = resData.token
                        //                        let NewResponse = TokenResponse(token: resData.token, role: resData.role)
                        tokenResponse.role = resData.role
                        tokenResponse.token = resData.token
                        self.role = resData.role
                        UserDefaults.standard.set(resData.token, forKey: "authToken")
                        UserDefaults.standard.set(resData.role, forKey: "role")
                        
                        return
                    }
                } catch {
                    print("ERROR")
                }
            }
        }.resume()
        
        return tokenResponse
    }
    
    func fetchAllUsers() {
        
        guard let url = URL(string: "https://bookwarden-server.onrender.com/api/librarian/getAllUsers") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Add authorization token to the request header
        let token = UserDefaults.standard.string(forKey: "authToken")!
        print(token)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching data: \(String(describing: error))")
                return
            }
            
            print(data)
            
            // Check response status code
            if let httpResponse = response as? HTTPURLResponse {
                if !(200...299).contains(httpResponse.statusCode) {
                    print("Error: HTTP status code \(httpResponse.statusCode)")
                    return
                }
            }
            
            do {
                let users = try JSONDecoder().decode([AllUserResponse].self, from: data)
                DispatchQueue.main.async {
                    self.allUsers = users
                    print("Users fetched and updated: \(self.allUsers)")
                }
            } catch {
                print("Error decoding data: \(error)")
            }
        }
        
        task.resume()
        
        
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
    
    func getRole(roleString : String) -> Role {
        switch roleString {
        case "" :
            return .normalUser
        case "jsgdg21672537612":
            return .librarian
        case "2543564fgfjghgfg435" :
            return .admin
        default :
            return .superAdmin
        }
    }
    
    // Function to fetch user details with authorization token
    func fetchUserDetails(accessToken: String, completion: @escaping (Result<ResponseData, Error>) -> Void) {
        guard let url = URL(string: "https://bookwarden-server.onrender.com/api/users/myProfile") else {
                print("Invalid URL")
                return
            }
            
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Add authorization token to the request header
        let token = UserDefaults.standard.string(forKey: "authToken")!
        print(token)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            print(String(data: data ?? Data(), encoding: .utf8) ?? "")
        }
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
