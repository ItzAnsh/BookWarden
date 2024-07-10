//
//  GenreManager.swift
//  BookWarden
//
//  Created by Ansh Bhasin on 01/06/24.
//

import Foundation

class GenreManager {
    private init() {}
    static let shared = GenreManager()
    
    private(set) var genres: [Genre] = []
    
    func addGenre(_ genre: Genre, completion: @escaping ((Result<Void, Error>) -> Void)) {
        genres.append(genre)
        // Optionally, you can save the genre to the backend here
        saveGenreToBackend(genre, completion: completion)
    }
    
    func removeGenre(byId id: String, completion: @escaping ((Result<Void, Error>) -> Void)) {
        genres.removeAll { $0.id == id }
        // Optionally, you can delete the genre from the backend here
        deleteGenreFromBackend(id: id, completion: completion)
    }
    
    func parseGenre(genreJson: [String : Any]) -> Genre? {
        guard let id = genreJson["_id"] as? String,
              let name = genreJson["name"] as? String
        else{
            return nil
        }
        return Genre(id: id, name: name, v: 0)
    }
    
    private func saveGenreToBackend(_ genre: Genre, completion: @escaping ((Result<Void, Error>) -> Void)) {
        // Example: use URLSession to save the genre to the backend
        guard let url = URL(string: "https://yourapi.com/saveGenre") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let jsonData = try encoder.encode(genre)
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
            
            // Handle success if needed
            completion(.success(()))
            
        }.resume()
    }
    
    private func deleteGenreFromBackend(id: String, completion: @escaping ((Result<Void, Error>) -> Void)) {
        // Example: use URLSession to delete the genre from the backend
        guard let url = URL(string: "https://yourapi.com/deleteGenre?id=\(id)") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
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
            
            // Handle success if needed
            completion(.success(()))
            
        }.resume()
    }
    
    enum NetworkError: Error {
        case invalidURL
        case badHTTPResponse
    }
}

