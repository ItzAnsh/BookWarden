import Foundation

struct LibraryCreateBody: Codable {
    var name: String
    var location: String
    var contactNo: String
    var contactEmail: String
    var totalBooks: Int
    var librarianEmail: String
    var maxBooks: Int
    var issuePeriod: Int
    var fineInterest: Int
}

class LibraryManager: ObservableObject {
    private init() {}
    static let shared = LibraryManager()
    
    @Published var libraries: [Library] = []
    
    func addLibrary(libraryRequestBody: LibraryCreateBody, accessToken: String, completion: @escaping (Result<Void, Error>) -> Void) {
            guard let url = URL(string: "https://bookwarden-server.onrender.com/api/admin/createLibrary") else {
                completion(.failure(NetworkError.invalidURL))
                return
            }
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            do {
                let jsonData = try JSONEncoder().encode(libraryRequestBody)
                urlRequest.httpBody = jsonData
            } catch {
                completion(.failure(NetworkError.encodingFailed))
                return
            }
            
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    completion(.failure(NetworkError.invalidResponse))
                    return
                }
                completion(.success(()))
            }.resume()
        }

    func getLibrary(byId id: String) -> Library? {
        return libraries.first { $0.getId() == id }
    }
    
    func updateLibrary(libraryId: String, updatedDetails: LibraryCreateBody, accessToken: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "https://bookwarden-server.onrender.com/api/admin/updateLibrary/\(libraryId)") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(updatedDetails)
            urlRequest.httpBody = jsonData
        } catch {
            completion(.failure(NetworkError.encodingFailed))
            return
        }
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            if httpResponse.statusCode == 200 {
                completion(.success(()))
            } else {
                completion(.failure(NetworkError.invalidResponse))
            }
        }.resume()
    }
    
    func updateLibraryBooks(byId id: String, books: [Book]?) {
        if let index = libraries.firstIndex(where: { $0.getId() == id }) {
            libraries[index].setBooks(books)
        }
    }
    
    func fetchLibraries(accessToken: String, completion: @escaping (Result<[Library], Error>) -> Void) {
        guard let url = URL(string: "https://bookwarden-server.onrender.com/api/admin/getAllLibraries") else {
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
                let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
                let libraries = jsonArray?.compactMap { dict -> Library? in
                    print(dict)
                    guard let id = dict["_id"] as? String,
                          let name = dict["name"] as? String,
                          let location = dict["location"] as? String,
                          let contactNo = dict["contactNo"] as? String,
                          let contactEmail = dict["contactEmail"] as? String,
                          let totalBooks = dict["totalBooks"] as? Int,
                          let issuePeriod = dict["issuePeriod"] as? Int,
                          let maxBooks = dict["maxBooks"] as? Int,
                          let fineInterest = dict["fineInterest"] as? Int,
                          let librarianDict = dict["librarian"] as? [String: Any],
                          let librarianId = librarianDict["_id"] as? String,
                          let librarianName = librarianDict["name"] as? String,
                          let librarianEmail = librarianDict["email"] as? String,
                          let adminId = librarianDict["adminId"] as? String
                    else {
                        return nil
                    }
//                    print("\(id) \(name) \(location) \(contactNo) \(contactEmail) \(librarianId)")
                    let librarian = User(id: librarianId, name: librarianName, email: librarianEmail, contactNo: "", genrePreferences: [], roles: .librarian)
                    
                    return Library(id: id,
                                   name: name,
                                   location: location,
                                   contactNo: contactNo,
                                   contactEmail: contactEmail,
                                   totalBooks: totalBooks,
                                   issuePeriod: issuePeriod,
                                   maxBooks: maxBooks,
                                   fineInterest: fineInterest,
                                   librarian: librarian,
                    adminId: adminId)
//                    Librar
                }
                DispatchQueue.main.async {
                    guard let libraries = libraries else {
                        completion(.failure(NetworkError.noData))
                        return
                    }
                    print(libraries)
                    self.libraries = libraries
                    completion(.success(libraries))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func deleteLibrary(libraryId: String, accessToken: String, completion: @escaping (Result<Void, Error>) -> Void) {
            guard let url = URL(string: "https://bookwarden-server.onrender.com/api/admin/deleteLibrary/\(libraryId)") else {
                completion(.failure(NetworkError.invalidURL))
                return
            }

            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "DELETE"
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
                completion(.success(()))
            }.resume()
        }
    
    func parseLibrary (libraryDictionary: [String: Any]) -> Library? {
        guard let id  = libraryDictionary["_id"] as? String,
              let name  = libraryDictionary["name"] as? String,
              let location = libraryDictionary["location"] as? String,
              let contactNo = libraryDictionary["contactNo"] as? String,
              let contactEmail = libraryDictionary["contactEmail"] as? String,
              let totalBooks = libraryDictionary["totalBooks"] as? String,
              let issuePeriod = libraryDictionary["issuePeriod"] as? Int,
              let maxBooks = libraryDictionary["maxBooks"] as? Int,
              let fineInterest = libraryDictionary["fineInterest"] as? Int,
              let adminId = libraryDictionary["adminId"] as? String
        else{
            return nil
        }
        return Library(id: id, name: name, location: location, contactNo: contactNo, contactEmail: contactEmail, totalBooks: 0, issuePeriod: issuePeriod, maxBooks: maxBooks, fineInterest: fineInterest, librarian: User(id: "id", name: "name", email: "email", contactNo: "11", genrePreferences: [], roles: .librarian), adminId: adminId)
    }
    enum LibraryManagerError: Error {
        case libraryAlreadyExists
    }
    
    enum NetworkError: Error {
        case invalidURL
        case invalidResponse
        case noData
        case encodingFailed
    }
}
