//
//  FineManager.swift
//  BookWarden
//
//  Created by Ansh Bhasin on 01/06/24.
//

import Foundation

class FineManager {
    private init() {}
    static let shared = FineManager()
    private(set) var fines: [Fine] = []
    
    func addFine(_ fine: Fine, accessToken: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard !fines.contains(where: { $0.id == fine.id }) else {
            completion(.failure(FineManagerError.fineAlreadyExists))
            return
        }
        fines.append(fine)
//        saveFineToBackend(fine, accessToken: accessToken, completion: completion)
    }
    
    func getFine(byId id: String) -> Fine? {
        return fines.first { $0.id == id }
    }
    
//    private func saveFineToBackend(_ fine: Fine, accessToken: String, completion: @escaping (Result<Void, Error>) -> Void) {
//        APIClient.shared.saveFine(fine, accessToken: accessToken, completion: completion)
//    }
//
//    func fetchFines(accessToken: String, completion: @escaping (Result<[Fine], Error>) -> Void) {
//        APIClient.shared.fetchFines(accessToken: accessToken) { result in
//            switch result {
//            case .success(let fines):
//                self.fines = fines
//                completion(.success(fines))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
    
    enum FineManagerError: Error {
        case fineAlreadyExists
    }
}
