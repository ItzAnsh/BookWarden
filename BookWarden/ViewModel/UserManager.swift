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

//@AppStorage("authToken") var authToken: String = ""

class UserManager: ObservableObject {
    private init() {}
    static let shared = UserManager()
    
    @Published private(set) var user: User?
    
    @Published var accessToken = ""
    @Published var role = ""
    
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
}

//var userManager = UserManager.shared



//var userManager = UserManager()
