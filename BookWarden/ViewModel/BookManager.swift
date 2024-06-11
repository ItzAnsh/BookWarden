//
//  BookManager.swift
//  BookWarden
//
//  Created by Ansh Bhasin on 01/06/24.
//

import Foundation

class BookManager: ObservableObject {
    static let shared = BookManager()
    
    @Published private(set) var books: [Book] = []
    
    private init() {}
    
    func addBook(_ book: Book) throws {
        guard !books.contains(where: { $0.id == book.id }) else {
            throw BookManagerError.bookAlreadyExists
        }
        books.append(book)
    }
    
    func getBook(byId id: String) -> Book? {
        return books.first { $0.id == id }
    }
    
    enum BookManagerError: Error {
        case bookAlreadyExists
    }
    
    enum NetworkError: Error {
        case invalidURL
        case unauthorized
        case invalidResponse
        case noData
    }
    
    func postDataRequest(accessToken: String, data: [String: Any], completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: "https://bookwarden-server.onrender.com/api/librarian/createBook") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: data, options: [])
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            guard let responseData = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            completion(.success(responseData))
        }.resume()
    }
    
    func fetchBooks(accessToken: String, completion: @escaping (Result<[Book], Error>) -> Void) {
        guard let url = URL(string: "https://bookwarden-server.onrender.com/api/users/getBooks") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Bearer \(UserDefaults.standard.string(forKey: "authToken")!)", forHTTPHeaderField: "Authorization")
        
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
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    let books = jsonArray.compactMap { dict -> Book? in
                        guard let id = dict["_id"] as? String,
                              let title = dict["title"] as? String,
                              let author = dict["author"] as? String,
                              let description = dict["description"] as? String,
                              let genreDictionary = dict["genre"] as? [String : Any],
                              let price = dict["price"] as? Double,
                              let publisher = dict["publisher"] as? String,
                              let language = dict["language"] as? String,
                              let length = dict["length"] as? Int,
                              let imageURLString = dict["imageURL"] as? String,
                              let imageURL = URL(string: imageURLString),
                              let isbn10 = dict["isbn10"] as? String,
                              let isbn13 = dict["isbn13"] as? String,
                              let v = dict["__v"] as? String
                        else {
                            print("Book data invalid")
                            return nil
                        }
                        
                        guard let genre = GenreManager.shared.parseGenre(genreJson: genreDictionary) else {
                            print("Couldn't parse genre")
                        
                        return Book(id: id,
                                    title: title,
                                    author: author,
                                    description: description,
                                    genre: genre,
                                    price: price,
                                    publisher: publisher,
                                    language: language,
                                    length: length,
                                    imageURL: imageURL,
                                    isbn10: isbn10,
                                    isbn13: isbn13,
                                    v: 0
                        )
                    }
                    
                    DispatchQueue.main.async {
                        self.books = books
                        completion(.success(books))
                    }
                } else {
                    completion(.failure(NetworkError.noData))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
      
    func parseBook (bookDictionary : [String : Any]) -> Book?{
        guard let id = bookDictionary["_id"] as? String,
              let author = bookDictionary["author"] as? String,
              let title = bookDictionary["title"] as? String,
              let publisher = bookDictionary["publisher"] as? String,
              let description = bookDictionary["description"] as? String,
              let genreDictionary = bookDictionary["genre"] as? [String : Any],
              let price = bookDictionary["price"] as? Double,
              let isbn10 = bookDictionary["isbn10"] as? String,
              let isbn13 = bookDictionary["isbn13"] as? String,
              let v = bookDictionary["__v"] as? Int,
              let language = bookDictionary["language"] as? String,
              let length = bookDictionary["length"] as? Int,
              let imageURLString = bookDictionary["imageURL"] as? String
        else{
            print("Something is mssing")
            return nil
        }
        guard let imageURL = URL(string: imageURLString) else {
            print("URL wrong")
            return nil
        }
        guard let genre = GenreManager.shared.parseGenre(genreJson: genreDictionary) else {
            print("Couldn't parse genre")
            return nil
        }
        return Book(id: id, title: title, author: author, description: description, genre: genre, price: price, publisher: publisher, language: language, length: length, imageURL: imageURL, isbn10: isbn10, isbn13: isbn13, v: v)
        
    }
    
    
    func fetchBookThroughISBN(code: String, completion: @escaping (Result<Book, Error>) -> Void) {
        guard code.count == 10 || code.count == 13 else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        guard let url = URL(string: "https://www.googleapis.com/books/v1/volumes?q=isbn:\(code)") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Bearer \(UserDefaults.standard.string(forKey: "authToken") ?? "")", forHTTPHeaderField: "Authorization")
        
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
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                guard let items = jsonResponse?["items"] as? [[String: Any]], let firstItem = items.first else {
                    completion(.failure(NetworkError.noData))
                    return
                }
                
                guard let volumeInfo = firstItem["volumeInfo"] as? [String: Any],
                      let id = firstItem["id"] as? String,
                      let title = volumeInfo["title"] as? String,
                      let authors = volumeInfo["authors"] as? [String], let author = authors.first,
                      let description = volumeInfo["description"] as? String,
                      let publisher = volumeInfo["publisher"] as? String,
                      let language = volumeInfo["language"] as? String,
                      let pageCount = volumeInfo["pageCount"] as? Int,
                      let imageLinks = volumeInfo["imageLinks"] as? [String: Any],
                      let imageURLString = imageLinks["thumbnail"] as? String,
                      let imageURL = URL(string: imageURLString),
                      let industryIdentifiers = volumeInfo["industryIdentifiers"] as? [[String: Any]] else {
                    completion(.failure(NetworkError.invalidResponse))
                    return
                }
                
                var isbn10 = ""
                var isbn13 = ""
                
                for identifier in industryIdentifiers {
                    if let type = identifier["type"] as? String, let value = identifier["identifier"] as? String {
                        if type == "ISBN_10" {
                            isbn10 = value
                        } else if type == "ISBN_13" {
                            isbn13 = value
                        }
                    }
                }
                
                // As genre and price are not available in the response, setting them to default values
                let genre = volumeInfo["categories"] as? [String] ?? ["Unknown"]
                let price = 0.0 // Default value as price is not in the response
                
                let book = Book(
                    id: id,
                    title: title,
                    author: author,
                    description: description,
                    genre: genre.first ?? "Unknown",
                    price: price,
                    publisher: publisher,
                    language: language,
                    length: pageCount,
                    imageURL: imageURL,
                    isbn10: isbn10,
                    isbn13: isbn13
                )
                
                DispatchQueue.main.async {
                    completion(.success(book))
                }
                
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func createBook(book: Book, token: String, completion: @escaping (Result<Void, Error>) -> Void) {
            if token.isEmpty {
                print("Bad token")
                completion(.failure(URLError(.userAuthenticationRequired)))
                return
            }

            guard let url = URL(string: "https://bookwarden-server.onrender.com/api/librarian/createBook") else {
                print("Invalid URL")
                completion(.failure(URLError(.badURL)))
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            do {
                let jsonData = try JSONEncoder().encode(book)
//                jsonData.append
                request.httpBody = jsonData
            } catch {
                completion(.failure(error))
                return
            }

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                    return
                }

                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        DispatchQueue.main.async {
                            self.books.append(book)
                            completion(.success(()))
                        }
                    } else {
                        DispatchQueue.main.async {
                            let serverError = NSError(domain: "HTTPError", code: httpResponse.statusCode, userInfo: [
                                "response": httpResponse,
                                "data": data ?? Data()
                            ])
                            completion(.failure(serverError))
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(.failure(URLError(.badServerResponse)))
                    }
                }
            }.resume()
        }
}

var bookManager = BookManager.shared
