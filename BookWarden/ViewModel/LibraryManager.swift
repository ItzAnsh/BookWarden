import Foundation

class LibraryManager: ObservableObject {
    private init() {}
    static let shared = LibraryManager()
    
    @Published private(set) var libraries: [Library] = []
    
    func addLibrary(library: Library, accessToken: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // Uncomment and complete the network request to add a library if needed
    }
    
    func getLibrary(byId id: String) -> Library? {
        return libraries.first { $0.getId() == id }
    }
    
    func updateLibraryBooks(byId id: String, books: [Book]?) {
        if let index = libraries.firstIndex(where: { $0.getId() == id }) {
            libraries[index].setBooks(books)
        }
    }
    
    func fetchLibraries(accessToken: String, completion: @escaping (Result<[Library], Error>) -> Void) {
        guard let url = URL(string: "https://bookwarden-server.onrender.com/api/library/getAllLibraries") else {
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
                          let librarianId = dict["librarian"] as? String else {
                        return nil
                    }
                    print("\(id) \(name) \(location) \(contactNo) \(contactEmail) \(librarianId)")
                    let librarian = User(id: librarianId, name: "", email: "", contactNo: "", genrePreferences: [], roles: .librarian)
                    
                    return Library(id: id,
                                   name: name,
                                   location: location,
                                   contactNo: contactNo,
                                   contactEmail: contactEmail,
                                   librarian: librarian)
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
