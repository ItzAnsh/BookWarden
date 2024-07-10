import Foundation

class APIClient2 {
    static let shared = APIClient2()
    
    private init() {}
    
    func fetchFines(accessToken: String, completion: @escaping (Result<[Fine], Error>) -> Void) {
        let apiUrl = ""
        guard let url = URL(string: "\(apiUrl)/fines") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            do {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .iso8601
                let fines = try jsonDecoder.decode([Fine].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(fines))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func saveFine(_ fine: Fine, accessToken: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let apiUrl = "https://bookwarden-server.onrender.com/"
        guard let url = URL(string: "\(apiUrl)/saveFine") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let jsonData = try encoder.encode(fine)
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NetworkError.badHTTPResponse))
                return
            }
            
            completion(.success(()))
        }.resume()
    }
    
    enum NetworkError: Error {
        case invalidURL
        case invalidResponse
        case noData
        case badHTTPResponse
    }
}

struct Fine: Codable, Hashable {
    let id: String
    let issueId: Issue
    let amount: Double
    var status: FineStatus
    let category: FineCategory
    var interest: Double
    var transactionId: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case issueId
        case amount
        case status
        case category
        case interest
        case transactionId
    }
    
    enum FineStatus: String, Codable {
        case pending = "Pending"
        case approved = "Approved"
        case completed = "Completed"
        case revoked = "Revoked"
    }

    enum FineCategory: String, Codable {
        case lostOrDamaged = "Lost or damaged"
        case dueDateExceeded = "Due date exceeded"
    }
    
    // Function to get book details based on issueId
    static func getBookDetails(forIssueId issueId: String, completion: @escaping ((Result<(amount: Int, interest: Int?), Error>) -> Void)) {
        let issueManager = IssueManager.shared
        guard let issue = issueManager.getIssue(byId: issueId) else {
            completion(.failure(FineInitializationError.bookDetailsNotFound))
            return
        }
        
        let bookManager = BookManager.shared
        guard let book = bookManager.getBook(byId: issue.getBook().id) else {
            completion(.failure(FineInitializationError.bookDetailsNotFound))
            return
        }
        
//        let bookDetails = (amount: book.getFineAmount(), interest: book.getFineInterest())
//        completion(.success(bookDetails))
    }
    
    enum FineInitializationError: Error {
        case bookDetailsNotFound
    }
}

