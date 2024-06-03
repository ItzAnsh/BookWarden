//
//  IssueManager.swift
//  BookWarden
//
//  Created by Ansh Bhasin on 01/06/24.
//

import Foundation

class IssueManager {
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
    
    func fetchIssues(accessToken: String, completion: @escaping (Result<[Issue], Error>) -> Void) {
        guard let url = URL(string: "https://your-api-url.com/issues") else {
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
                let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
                let issues = jsonArray?.compactMap { dict -> Issue? in
                    guard let id = dict["_id"] as? String,
                          let bookId = dict["bookId"] as? String,
                          let userId = dict["userId"] as? String,
                          let issuedDateString = dict["issuedDate"] as? String,
                          let deadlineString = dict["deadline"] as? String,
                          let statusString = dict["status"] as? String,
                          let issuedDate = ISO8601DateFormatter().date(from: issuedDateString),
                          let deadline = ISO8601DateFormatter().date(from: deadlineString),
                          let status = IssueStatus(rawValue: statusString) else {
                        return nil
                    }
                    
                    let returnDate: Date? = {
                        if let returnDateString = dict["returnDate"] as? String {
                            return ISO8601DateFormatter().date(from: returnDateString)
                        }
                        return nil
                    }()
                    
                    return Issue(id: id,
                                 bookId: bookId,
                                 userId: userId,
                                 issuedDate: issuedDate,
                                 deadline: deadline,
                                 status: status,
                                 returnDate: returnDate)
                }
                DispatchQueue.main.async {
                    guard let issues = issues else {
                        completion(.failure(NetworkError.noData))
                        return
                    }
                    self.issues = issues
                    completion(.success(issues))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
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
    }
}
