//
//  BookManager.swift
//  BookWarden
//
//  Created by Ansh Bhasin on 01/06/24.
//

import Foundation

var apiUrl = "https://bookwarden-server.onrender.com/api"

class BookManager: ObservableObject {
    static let shared = BookManager()
    
    @Published private(set) var books: [Book] = []
    @Published private(set) var categories: [Category] = []
    
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
    func fetchPreferredBooks(accessToken: String, completion: @escaping (Result<[Book], Error>) -> Void) {
        guard let url = URL(string: "https://bookwarden-server.onrender.com/api/users/home") else {
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
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let preferredBooksArray = json?["PreferredBooks"] as? [[String: Any]] {
                    let preferredBooks = preferredBooksArray.compactMap { self.parseBook(bookDictionary: $0) }
                    print(preferredBooks)
                    
                    DispatchQueue.main.async {
                        completion(.success(preferredBooks))
                    }
                } else {
                    completion(.failure(NetworkError.noData))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchRecentBooks(accessToken: String, completion: @escaping (Result<[Book], Error>) -> Void) {
        guard let url = URL(string: "https://bookwarden-server.onrender.com/api/users/home") else {
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
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let recentBooksArray = json?["RecentBooks"] as? [[String: Any]] {
                    let recentBooks = recentBooksArray.compactMap { self.parseBook(bookDictionary: $0) }
                    
                    DispatchQueue.main.async {
                        completion(.success(recentBooks))
                    }
                } else {
                    completion(.failure(NetworkError.noData))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchCategories(accessToken: String, completion: @escaping (Result<[Category], Error>) -> Void) {
            guard let url = URL(string: "https://bookwarden-server.onrender.com/api/users/home") else {
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
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    if let categoriesDictionary = json?["Categories"] as? [String: Any],
                       let allGenresArray = categoriesDictionary["AllGenres"] as? [[String: Any]] {
                        let categories = allGenresArray.compactMap { self.parseCategory(categoryDictionary: $0) }
                        
                        DispatchQueue.main.async {
                            self.categories = categories
                            completion(.success(categories))
                        }
                    } else {
                        completion(.failure(NetworkError.noData))
                    }
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        }
    
    
    private func parseCategory(categoryDictionary: [String: Any]) -> Category? {
            guard let id = categoryDictionary["_id"] as? String,
                  let name = categoryDictionary["name"] as? String,
                  let booksArray = categoryDictionary["books"] as? [[String: Any]] else {
                print("Category data invalid")
                return nil
            }
            
            let books = booksArray.compactMap { self.parseBook(bookDictionary: $0) }
            
            return Category(id: id, name: name, books: books)
        }
    func fetchBooks(accessToken: String, completion: @escaping (Result<[Book], Error>) -> Void) {
        guard let url = URL(string: "https://bookwarden-server.onrender.com/api/users/getBooks") else {
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
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    print(String(data: data, encoding: .utf8) ?? "")
                    let books = jsonArray.compactMap { dict -> Book? in
                        guard let id = dict["_id"] as? String,
                              let title = dict["title"] as? String,
                              let author = dict["author"] as? String,
                              let description = dict["description"] as? String,
                              let genreDictionary = dict["genre"] as? [String: Any],
                              let genreName = genreDictionary["name"] as? String,
                              let genreId = genreDictionary["_id"] as? String,
                              let price = dict["price"] as? Double,
                              let publisher = dict["publisher"] as? String,
                              let language = dict["language"] as? String,
                              let length = dict["length"] as? Int,
                              let imageURLString = dict["imageURL"] as? String,
                              let imageURL = URL(string: imageURLString),
                              let isbn10 = dict["isbn10"] as? String,
                              let isbn13 = dict["isbn13"] as? String,
                              let v = dict["__v"] as? Int,
                              let locationsArray = dict["locations"] as? [[String: Any]] else {
                            print("Book data invalid")
                            return nil
                        }

                        let locations: [Location] = locationsArray.compactMap { locationDict in
                            guard let libraryDict = locationDict["libraryId"] as? [String: Any],
                                  let libraryId = libraryDict["_id"] as? String,
                                  let libraryName = libraryDict["name"] as? String,
                                  let libraryLocation = libraryDict["location"] as? String,
                                  let contactNo = libraryDict["contactNo"] as? String,
                                  let contactEmail = libraryDict["contactEmail"] as? String,
                                  let librarianDict = libraryDict["librarian"] as? [String: Any],
                                  let librarianId = librarianDict["_id"] as? String,
                                  let librarianName = librarianDict["name"] as? String,
                                  let librarianEmail = librarianDict["email"] as? String,
//                                  let librarianPassword = librarianDict["password"] as? String,
//                                  let librarianRole = librarianDict["role"] as? String,
                                  let librarianAdminId = librarianDict["adminId"] as? String,
//                                  let librarianDate = librarianDict["date"] as? String,
                                  let librarianV = librarianDict["__v"] as? Int,
                                  let totalBooks = libraryDict["totalBooks"] as? Int,
                                  let adminId = libraryDict["adminId"] as? String,
                                  let issuePeriod = libraryDict["issuePeriod"] as? Int,
                                  let maxBooks = libraryDict["maxBooks"] as? Int,
                                  let fineInterest = libraryDict["fineInterest"] as? Int,
                                  let libraryV = libraryDict["__v"] as? Int,
                                  let totalQuantity = locationDict["totalQuantity"] as? Int,
                                  let availableQuantity = locationDict["availableQuantity"] as? Int else {
                                return nil
                            }

                            let librarian = User(
                                id: librarianId,
                                name: librarianName,
                                email: librarianEmail,
                                contactNo: contactNo,
                                genrePreferences: [],
                                roles: .librarian
                            )

                            let library = Library(
                                id: libraryId,
                                name: libraryName,
                                location: libraryLocation,
                                contactNo: contactNo,
                                contactEmail: contactEmail,
                                totalBooks: totalBooks,
                                issuePeriod: issuePeriod,
                                maxBooks: maxBooks,
                                fineInterest: fineInterest,
                                librarian: librarian,
                                adminId: adminId
                            )

                            return Location(
                                id: library.id,
                                libraryId: library,
                                bookId: id,
                                totalQuantity: totalQuantity,
                                availableQuantity: availableQuantity,
                                v: libraryV
                            )
                        }

                        guard let genre = GenreManager.shared.parseGenre(genreJson: genreDictionary) else {
                            print("Couldn't parse genre")
                            return nil
                        }

                        return Book(
                            id: id,
                            title: title,
                            author: author,
                            description: description,
                            genre: Genre(id: genreId, name: genreName, v: 0),
                            price: price,
                            publisher: publisher,
                            language: language,
                            length: length,
                            imageURL: imageURL,
                            isbn10: isbn10,
                            isbn13: isbn13,
                            v: v,
                            location: locations
                        )
                    }

                    DispatchQueue.main.async {
                        print(books)
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
            let dict = bookDictionary
            guard let id = dict["_id"] as? String,
                  let title = dict["title"] as? String,
                  let author = dict["author"] as? String,
                  let description = dict["description"] as? String,
                  let genreDictionary = dict["genre"] as? [String: Any],
                  let genreName = genreDictionary["name"] as? String,
                  let genreId = genreDictionary["_id"] as? String,
                  let price = dict["price"] as? Double,
                  let publisher = dict["publisher"] as? String,
                  let language = dict["language"] as? String,
                  let length = dict["length"] as? Int,
                  let imageURLString = dict["imageURL"] as? String,
                  let imageURL = URL(string: imageURLString),
                  let isbn10 = dict["isbn10"] as? String,
                  let isbn13 = dict["isbn13"] as? String,
                  let v = dict["__v"] as? Int,
                  let locationsArray = dict["locations"] as? [[String: Any]] else {
                print("Book data invalid")
                return nil
            }

            let locations: [Location] = locationsArray.compactMap { locationDict in
                guard let libraryDict = locationDict["libraryId"] as? [String: Any],
                      let libraryId = libraryDict["_id"] as? String,
                      let libraryName = libraryDict["name"] as? String,
                      let libraryLocation = libraryDict["location"] as? String,
                      let contactNo = libraryDict["contactNo"] as? String,
                      let contactEmail = libraryDict["contactEmail"] as? String,
                      let librarianDict = libraryDict["librarian"] as? [String: Any],
                      let librarianId = librarianDict["_id"] as? String,
                      let librarianName = librarianDict["name"] as? String,
                      let librarianEmail = librarianDict["email"] as? String,
//                                  let librarianPassword = librarianDict["password"] as? String,
//                                  let librarianRole = librarianDict["role"] as? String,
                      let librarianAdminId = librarianDict["adminId"] as? String,
//                                  let librarianDate = librarianDict["date"] as? String,
                      let librarianV = librarianDict["__v"] as? Int,
                      let totalBooks = libraryDict["totalBooks"] as? Int,
                      let adminId = libraryDict["adminId"] as? String,
                      let issuePeriod = libraryDict["issuePeriod"] as? Int,
                      let maxBooks = libraryDict["maxBooks"] as? Int,
                      let fineInterest = libraryDict["fineInterest"] as? Int,
                      let libraryV = libraryDict["__v"] as? Int,
                      let totalQuantity = locationDict["totalQuantity"] as? Int,
                      let availableQuantity = locationDict["availableQuantity"] as? Int else {
                    return nil
                }

                let librarian = User(
                    id: librarianId,
                    name: librarianName,
                    email: librarianEmail,
                    contactNo: contactNo,
                    genrePreferences: [],
                    roles: .librarian
                )

                let library = Library(
                    id: libraryId,
                    name: libraryName,
                    location: libraryLocation,
                    contactNo: contactNo,
                    contactEmail: contactEmail,
                    totalBooks: totalBooks,
                    issuePeriod: issuePeriod,
                    maxBooks: maxBooks,
                    fineInterest: fineInterest,
                    librarian: librarian,
                    adminId: adminId
                )

                return Location(
                    id: library.id,
                    libraryId: library,
                    bookId: id,
                    totalQuantity: totalQuantity,
                    availableQuantity: availableQuantity,
                    v: libraryV
                )
            }

            guard let genre = GenreManager.shared.parseGenre(genreJson: genreDictionary) else {
                print("Couldn't parse genre")
                return nil
            }
        
        return Book(id: id, title: title, author: author, description: description, genre: genre, price: price, publisher: publisher, language: language, length: length, imageURL: imageURL, isbn10: isbn10, isbn13: isbn13, v: v, location: locations)
    }
    
    
    func fetchBooksLibrarian(accessToken: String, completion: @escaping (Result<[Book], Error>) -> Void) {
        guard let url = URL(string: "https://bookwarden-server.onrender.com/api/librarian/getAllBooks") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        //        func fetchBookThroughISBN(code: String, completion: @escaping (Result<Book, Error>) -> Void) {
        //            guard code.count == 10 || code.count == 13 else {
        //                completion(.failure(NetworkError.invalidURL))
        //                return
        //            }
        //
        //            guard let url = URL(string: "https://www.googleapis.com/books/v1/volumes?q=isbn:\(code)") else {
        //                completion(.failure(NetworkError.invalidURL))
        //                return
        //            }
        //
        //            var urlRequest = URLRequest(url: url)
        //            urlRequest.httpMethod = "GET"
        //            urlRequest.setValue("Bearer \(UserDefaults.standard.string(forKey: "authToken") ?? "")", forHTTPHeaderField: "Authorization")
        //
        //            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
        //                if let error = error {
        //                    completion(.failure(error))
        //                    return
        //                }
        //
        //                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        //                    completion(.failure(NetworkError.invalidResponse))
        //                    return
        //                }
        //
        //                guard let data = data else {
        //                    completion(.failure(NetworkError.noData))
        //                    return
        //                }
        //
        //                do {
        //                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        //                    guard let items = jsonResponse?["items"] as? [[String: Any]], let firstItem = items.first else {
        //                        completion(.failure(NetworkError.noData))
        //                        return
        //                    }
        //
        //                    guard let volumeInfo = firstItem["volumeInfo"] as? [String: Any],
        //                          let id = firstItem["id"] as? String,
        //                          let title = volumeInfo["title"] as? String,
        //                          let authors = volumeInfo["authors"] as? [String], let author = authors.first,
        //                          let description = volumeInfo["description"] as? String,
        //                          let genreDictionary = volumeInfo["genre"] as? [String: Any],
        //                          let publisher = volumeInfo["publisher"] as? String,
        //                          let language = volumeInfo["language"] as? String,
        //                          let pageCount = volumeInfo["pageCount"] as? Int,
        //                          let imageLinks = volumeInfo["imageLinks"] as? [String: Any],
        //                          let imageURLString = imageLinks["thumbnail"] as? String,
        //                          let imageURL = URL(string: imageURLString),
        //                          let industryIdentifiers = volumeInfo["industryIdentifiers"] as? [[String: Any]] else {
        //                        completion(.failure(NetworkError.invalidResponse))
        //                        return
        //                    }
        //
        //                    var isbn10 = ""
        //                    var isbn13 = ""
        //
        //                    for identifier in industryIdentifiers {
        //                        if let type = identifier["type"] as? String, let value = identifier["identifier"] as? String {
        //                            if type == "ISBN_10" {
        //                                isbn10 = value
        //                            } else if type == "ISBN_13" {
        //                                isbn13 = value
        //                            }
        //                        }
        //                    }
        //
        //                    // As genre and price are not available in the response, setting them to default values
        //                    let genre = volumeInfo["categories"] as? [String] ?? ["Unknown"]
        //                    let price = 0.0 // Default value as price is not in the response
        //
        //                    let book = Book(
        //                        id: id,
        //                        title: title,
        //                        author: author,
        //                        description: description,
        //                        genre: .none,
        //                        price: price,
        //                        publisher: publisher,
        //                        language: language,
        //                        length: pageCount,
        //                        imageURL: imageURL,
        //                        isbn10: isbn10,
        //                        isbn13: isbn13,
        //                        v: 0
        //                    )
        //
        //                    DispatchQueue.main.async {
        //                        completion(.success(book))
        //                    }
        //
        //                } catch {
        //                    completion(.failure(error))
        //                }
        //            }.resume()
        //        }
    }
    
    
    //    func createBook(book: Book, token: String, completion: @escaping (Result<Void, Error>) -> Void) {
    //        if token.isEmpty {
    //            print("Bad token")
    //            completion(.failure(URLError(.userAuthenticationRequired)))
    //            return
    //        }
    //
    //        guard let url = URL(string: "https://bookwarden-server.onrender.com/api/librarian/createBook") else {
    //            print("Invalid URL")
    //            completion(.failure(URLError(.badURL)))
    //            return
    //        }
    //
    //        var request = URLRequest(url: url)
    //        request.httpMethod = "POST"
    //        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    //        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    //
    //        do {
    //            let jsonData = try JSONEncoder().encode(book)
    //            //                jsonData.append
    //            request.httpBody = jsonData
    //        } catch {
    //            completion(.failure(error))
    //            return
    //        }
    //
    //        URLSession.shared.dataTask(with: request) { data, response, error in
    //            if let error = error {
    //                print(error)
    //                completion(.failure(error))
    //                return
    //            }
    //
    //            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
    //                completion(.failure(NetworkError.invalidResponse))
    //                return
    //            }
    //
    //            guard let data = data else {
    //                completion(.failure(NetworkError.noData))
    //                return
    //            }
    //
    //            do {
    //                if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
    //                    let books = jsonArray.compactMap { dict -> Book? in
    //                        guard let id = dict["_id"] as? String,
    //                              let title = dict["title"] as? String,
    //                              let author = dict["author"] as? String,
    //                              let description = dict["description"] as? String,
    //                              let genreDictionary = dict["genre"] as? [String : Any],
    //                              let price = dict["price"] as? Double,
    //                              let publisher = dict["publisher"] as? String,
    //                              let language = dict["language"] as? String,
    //                              let length = dict["length"] as? Int,
    //                              let imageURLString = dict["imageURL"] as? String,
    //                              let imageURL = URL(string: imageURLString),
    //                              let isbn10 = dict["isbn10"] as? String,
    //                              let isbn13 = dict["isbn13"] as? String,
    //                              let v = dict["__v"] as? Int
    //                        else {
    //                            return nil
    //                        }
    //
    //                        guard let genre = GenreManager.shared.parseGenre(genreJson: genreDictionary) else {
    //                            print("Couldn't parse genre")
    //                            return nil
    //                        }
    //                        print(id)
    //                        return Book(id: id,
    //                                    title: title,
    //                                    author: author,
    //                                    description: description,
    //                                    genre: genre,
    //                                    price: price,
    //                                    publisher: publisher,
    //                                    language: language,
    //                                    length: length,
    //                                    imageURL: imageURL,
    //                                    isbn10: isbn10,
    //                                    isbn13: isbn13,
    //                                    v:v
    //                        )
    //
    //                    }
    //                    DispatchQueue.main.async {
    //                        self.books = books
    //                        completion(.success(()))
    //                    }
    //                } else {
    //                    completion(.failure(NetworkError.noData))
    //                }
    //
    //            } catch {
    //                completion(.failure(error))
    //            }
    //        }.resume()
    //    }
    
    
    //    func fetchBookThroughISBN(code: String, completion: @escaping (Result<Book, Error>) -> Void) {
    //        guard code.count == 10 || code.count == 13 else {
    //            completion(.failure(NetworkError.invalidURL))
    //            return
    //        }
    //
    //        guard let url = URL(string: "https://www.googleapis.com/books/v1/volumes?q=isbn:\(code)") else {
    //            completion(.failure(NetworkError.invalidURL))
    //            return
    //        }
    //
    //        var urlRequest = URLRequest(url: url)
    //        urlRequest.httpMethod = "GET"
    //        urlRequest.setValue("Bearer \(UserDefaults.standard.string(forKey: "authToken") ?? "")", forHTTPHeaderField: "Authorization")
    //
    //        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
    //            if let error = error {
    //                completion(.failure(error))
    //                return
    //            }
    //
    //            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
    //                completion(.failure(NetworkError.invalidResponse))
    //                return
    //            }
    //
    //            guard let data = data else {
    //                completion(.failure(NetworkError.noData))
    //                return
    //            }
    //
    //            do {
    //                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
    //                guard let items = jsonResponse?["items"] as? [[String: Any]], let firstItem = items.first else {
    //                    completion(.failure(NetworkError.noData))
    //                    return
    //                }
    //
    //                guard let volumeInfo = firstItem["volumeInfo"] as? [String: Any],
    //                      let id = firstItem["id"] as? String,
    //                      let title = volumeInfo["title"] as? String,
    //                      let authors = volumeInfo["authors"] as? [String], let author = authors.first,
    //                      let description = volumeInfo["description"] as? String,
    //                      let publisher = volumeInfo["publisher"] as? String,
    //                      let language = volumeInfo["language"] as? String,
    //                      let pageCount = volumeInfo["pageCount"] as? Int,
    //                      let imageLinks = volumeInfo["imageLinks"] as? [String: Any],
    //                      let imageURLString = imageLinks["thumbnail"] as? String,
    //                      let imageURL = URL(string: imageURLString),
    //                      let industryIdentifiers = volumeInfo["industryIdentifiers"] as? [[String: Any]] else {
    //                    completion(.failure(NetworkError.invalidResponse))
    //                    return
    //                }
    //
    //                var isbn10 = ""
    //                var isbn13 = ""
    //
    //                for identifier in industryIdentifiers {
    //                    if let type = identifier["type"] as? String, let value = identifier["identifier"] as? String {
    //                        if type == "ISBN_10" {
    //                            isbn10 = value
    //                        } else if type == "ISBN_13" {
    //                            isbn13 = value
    //                        }
    //                    }
    //                }
    //
    //                // As genre and price are not available in the response, setting them to default values
    //                let genre = volumeInfo["categories"] as? [String] ?? ["Unknown"]
    //                let price = 0.0 // Default value as price is not in the response
    //
    //                let book = Book(
    //                    id: id,
    //                    title: title,
    //                    author: author,
    //                    description: description,
    //                    genre: genre.first ?? "Unknown",
    //                    price: price,
    //                    publisher: publisher,
    //                    language: language,
    //                    length: pageCount,
    //                    imageURL: imageURL,
    //                    isbn10: isbn10,
    //                    isbn13: isbn13
    //                )
    //
    //                DispatchQueue.main.async {
    //                    completion(.success(book))
    //                }
    //
    //            } catch {
    //                completion(.failure(error))
    //            }
    //        }.resume()
    //    }
    //
    //    func createBook(book: Book, token: String, completion: @escaping (Result<Void, Error>) -> Void) {
    //            if token.isEmpty {
    //                print("Bad token")
    //                completion(.failure(URLError(.userAuthenticationRequired)))
    //                return
    //            }
    //
    //            guard let url = URL(string: "https://bookwarden-server.onrender.com/api/librarian/createBook") else {
    //                print("Invalid URL")
    //                completion(.failure(URLError(.badURL)))
    //                return
    //            }
    //
    //            var request = URLRequest(url: url)
    //            request.httpMethod = "POST"
    //            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    //            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    //
    //            do {
    //                let jsonData = try JSONEncoder().encode(book)
    ////                jsonData.append
    //                request.httpBody = jsonData
    //            } catch {
    //                completion(.failure(error))
    //                return
    //            }
    //
    //            URLSession.shared.dataTask(with: request) { data, response, error in
    //                if let error = error {
    //                    DispatchQueue.main.async {
    //                        completion(.failure(error))
    //                    }
    //                    return
    //                }
    //
    //                if let httpResponse = response as? HTTPURLResponse {
    //                    if httpResponse.statusCode == 200 {
    //                        DispatchQueue.main.async {
    //                            self.books.append(book)
    //                            completion(.success(()))
    //                        }
    //                    } else {
    //                        DispatchQueue.main.async {
    //                            let serverError = NSError(domain: "HTTPError", code: httpResponse.statusCode, userInfo: [
    //                                "response": httpResponse,
    //                                "data": data ?? Data()
    //                            ])
    //                            completion(.failure(serverError))
    //                        }
    //                    }
    //                } else {
    //                    DispatchQueue.main.async {
    //                        completion(.failure(URLError(.badServerResponse)))
    //                    }
    //                }
    //            }.resume()
    //        }
    
    func deleteBook(bookID: String, accessToken: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "https://bookwarden-server.onrender.com/api/librarian/deleteBook/\(bookID)") else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        print(url)
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(UserDefaults.standard.string(forKey: "authToken") ?? "")", forHTTPHeaderField: "Authorization")
        print("Request \(request)")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                DispatchQueue.main.async {
                    self.books.removeAll { $0.id == bookID }
                    print("Domne")
                    completion(.success(()))
                    print("Book Deleted")
                }
            } else {
                //                    print(httpResponse.statusCode)
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to delete book"])))
            }
        }.resume()
        
        //                return
    }
    
    func issueBook(bookId: String, libraryId: String, accessToken: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(apiUrl)/users/issueBook") else {
            completion(.failure(NetworkError.invalidURL))
            print("invalid url")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(UserDefaults.standard.string(forKey: "authToken") ?? "")", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["bookId": bookId, "libraryId": libraryId]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            print(String(data: request.httpBody ?? Data(), encoding: .utf8)!)
        } catch {
            print("error found")
        }
        
        URLSession.shared.dataTask(with: request) {
            data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                DispatchQueue.main.async {
                    //                        self.books.removeAll { $0.id == bookID }
                    print("Domne")
                    completion(.success(()))
//                    print("Book Deleted")
                }
            } else {
                //                    print(httpResponse.statusCode)
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to delete book"])))
            }
        }.resume()
    }
    
//    func bookParser(bookDict: [String: Any]) -> Book? {
//        let books = bookDict.compactMap { dict -> Book? in
//            guard let id = dict["_id"] as? String,
//                  let title = dict["title"] as? String,
//                  let author = dict["author"] as? String,
//                  let description = dict["description"] as? String,
//                  let genreDictionary = dict["genre"] as? [String: Any],
//                  let genreName = genreDictionary["name"] as? String,
//                  let genreId = genreDictionary["_id"] as? String,
//                  let price = dict["price"] as? Double,
//                  let publisher = dict["publisher"] as? String,
//                  let language = dict["language"] as? String,
//                  let length = dict["length"] as? Int,
//                  let imageURLString = dict["imageURL"] as? String,
//                  let imageURL = URL(string: imageURLString),
//                  let isbn10 = dict["isbn10"] as? String,
//                  let isbn13 = dict["isbn13"] as? String,
//                  let v = dict["__v"] as? Int,
//                  let locationsArray = dict["locations"] as? [[String: Any]] else {
//                print("Book data invalid")
//                return nil
//            }
//
//            let locations: [Location] = locationsArray.compactMap { locationDict in
//                guard let libraryDict = locationDict["libraryId"] as? [String: Any],
//                      let libraryId = libraryDict["_id"] as? String,
//                      let libraryName = libraryDict["name"] as? String,
//                      let libraryLocation = libraryDict["location"] as? String,
//                      let contactNo = libraryDict["contactNo"] as? String,
//                      let contactEmail = libraryDict["contactEmail"] as? String,
//                      let librarianDict = libraryDict["librarian"] as? [String: Any],
//                      let librarianId = librarianDict["_id"] as? String,
//                      let librarianName = librarianDict["name"] as? String,
//                      let librarianEmail = librarianDict["email"] as? String,
////                                  let librarianPassword = librarianDict["password"] as? String,
////                                  let librarianRole = librarianDict["role"] as? String,
//                      let librarianAdminId = librarianDict["adminId"] as? String,
////                                  let librarianDate = librarianDict["date"] as? String,
//                      let librarianV = librarianDict["__v"] as? Int,
//                      let totalBooks = libraryDict["totalBooks"] as? Int,
//                      let adminId = libraryDict["adminId"] as? String,
//                      let issuePeriod = libraryDict["issuePeriod"] as? Int,
//                      let maxBooks = libraryDict["maxBooks"] as? Int,
//                      let fineInterest = libraryDict["fineInterest"] as? Int,
//                      let libraryV = libraryDict["__v"] as? Int,
//                      let totalQuantity = locationDict["totalQuantity"] as? Int,
//                      let availableQuantity = locationDict["availableQuantity"] as? Int else {
//                    return nil
//                }
//
//                let librarian = User(
//                    id: librarianId,
//                    name: librarianName,
//                    email: librarianEmail,
//                    contactNo: contactNo,
//                    genrePreferences: [],
//                    roles: .librarian
//                )
//
//                let library = Library(
//                    id: libraryId,
//                    name: libraryName,
//                    location: libraryLocation,
//                    contactNo: contactNo,
//                    contactEmail: contactEmail,
//                    totalBooks: totalBooks,
//                    issuePeriod: issuePeriod,
//                    maxBooks: maxBooks,
//                    fineInterest: fineInterest,
//                    librarian: librarian,
//                    adminId: adminId
//                )
//
//                return Location(
//                    id: library.id,
//                    libraryId: library,
//                    bookId: id,
//                    totalQuantity: totalQuantity,
//                    availableQuantity: availableQuantity,
//                    v: libraryV
//                )
//            }
//
//            guard let genre = GenreManager.shared.parseGenre(genreJson: genreDictionary) else {
//                print("Couldn't parse genre")
//                return nil
//            }
//
//            return Book(
//                id: id,
//                title: title,
//                author: author,
//                description: description,
//                genre: Genre(id: genreId, name: genreName, v: 0),
//                price: price,
//                publisher: publisher,
//                language: language,
//                length: length,
//                imageURL: imageURL,
//                isbn10: isbn10,
//                isbn13: isbn13,
//                v: v,
//                location: locations
//            )
//    }
}



var bookManager = BookManager.shared


struct issueBookData: Codable {
    var bookId: String
    var libraryId: String
}
