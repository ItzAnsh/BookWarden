//
//  IssueManager.swift
//  BookWarden
//
//  Created by Ansh Bhasin on 01/06/24.
//

import Foundation

class IssueManager: ObservableObject {
    private init() {}
    static let shared = IssueManager()
    
    private(set) var issues: [Issue] = []
    
    func addIssue(_ issue: Issue, accessToken: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard !issues.contains(where: { $0.getId() == issue.getId() }) else {
            completion(.failure(IssueManagerError.issueAlreadyExists))
            return
        }
        issues.append(issue)
        saveIssueToBackend(issue, accessToken: accessToken, completion: completion)
    }
    
    func getIssue(byId id: String) -> Issue? {
        return issues.first { $0.getId() == id }
    }
    
    func updateIssueStatus(byId id: String, status: IssueStatus) {
        if let index = issues.firstIndex(where: { $0.getId() == id }) {
            issues[index].setStatus(status)
        }
    }
    
    func updateReturnDate(byId id: String, returnDate: Date?) {
        if let index = issues.firstIndex(where: { $0.getId() == id }) {
            issues[index].setReturnDate(returnDate)
        }
    }
    
    func getIssueStatus(issueString : String) -> IssueStatus {
        switch issueString{
        case "rejected" :
            return .rejected
        case "requested" :
            return .requested
        case "issued" :
            return .issued
        case "returned" :
            return .returned
        case "fined" :
            return .fined
        case "fining" :
            return .fining
        default :
            return .issued
        }
    }
    
    func fetchIssueDetails(issueId: String, accessToken: String, completion: @escaping (Result<Issue, Error>) -> Void) {
        guard let url = URL(string: "https://bookwarden-server.onrender.com/api/librarian/getSpecificIssue/\(issueId)") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Bearer \(UserManager.shared.accessToken)", forHTTPHeaderField: "Authorization")
        print("Token: \(UserManager.shared.accessToken)")
        
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
                guard let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                    completion(.failure(NetworkError.invalidData))
                    return
                }
                guard let issue = self.parseIssue(jsonDictionary: jsonObject) else {
                    print("Couldn't parse issue")
                    completion(.failure(NetworkError.invalidData))
                    return
                }
                completion(.success(issue))
            } catch {
                completion(.failure(NetworkError.decodingError))
            }
        }.resume()
    }

    func parseIssue(jsonDictionary : [String: Any]) -> Issue? {
        guard let userJson = jsonDictionary["userId"] as? [String: Any],
              let user = UserManager.shared.parseUser(userDictionary: userJson)
        else {
            print("Could't parse user")
            return nil
        }
        
        guard let bookJson = jsonDictionary["bookId"] as? [String: Any],
              let book = BookManager.shared.parseBook(bookDictionary: bookJson)
        else{
            print("Couldn't parse Book")
            return nil
        }
        
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds] // Include fractional seconds

        
        guard let issueDateString = jsonDictionary["date"] as? String,
              let date = isoFormatter.date(from: issueDateString)
        else {
            print("Couldn't parse dates")
            return nil
        }
        
        guard let deadlineDateString = jsonDictionary["deadline"] as? String,
              let deadlineDate = isoFormatter.date(from: deadlineDateString)
        else {
            print("Couldn't parsess dates")
            return nil
        }
        
        
        guard let statusString = jsonDictionary["status"] as? String,
              let id = jsonDictionary["_id"] as? String
        else {
            print("Couldn't parse status")
            return nil
        }
        let status = getIssueStatus(issueString: statusString)
        return Issue(id: id, book: book, user: user, issuedDate: date, deadline: deadlineDate, status: status)
    }
    
    private func saveIssueToBackend(_ issue: Issue, accessToken: String, completion: @escaping (Result<Void, Error>) -> Void) {
            guard let url = URL(string: "https://your-api-url.com/saveIssue") else {
                completion(.failure(NetworkError.invalidURL))
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            
            do {
                let encoder = JSONEncoder()
                encoder.dateEncodingStrategy = .iso8601
                let jsonData = try encoder.encode(issue)
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
    enum IssueManagerError: Error {
        case issueAlreadyExists
    }
    
    enum NetworkError: Error {
        case invalidURL
        case invalidResponse
        case noData
        case badHTTPResponse
        case decodingError
        case invalidData
    }
}
