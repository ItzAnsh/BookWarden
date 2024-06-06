//
//  PasswordChangeViewModel.swift
//  BookWarden
//
//  Created by Abhi  on 06/06/24.
//

import Foundation
import SwiftUI
import Combine

class PasswordChangeViewModel: ObservableObject {
    @Published var oldPassword = ""
    @Published var newPassword = ""
    @Published var confirmPassword = ""
    @Published var showAlert = false
    @Published var alertMessage = ""

    private var cancellables = Set<AnyCancellable>()

    func changePassword() {
        // Check if the new password and confirm password match
        guard newPassword == confirmPassword else {
            alertMessage = "New Password and Confirm Password do not match."
            showAlert = true
            return
        }

        // Example URL and request for password change API
        guard let url = URL(string: "https://bookwarden-server.onrender.com/api/users/updatePassword") else {
            alertMessage = "Invalid URL."
            showAlert = true
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        // Example parameters for the API request
        let parameters: [String: Any] = [
            "oldPassword": oldPassword,
            "newPassword": newPassword
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            alertMessage = "Failed to serialize JSON."
            showAlert = true
            return
        }

        // Add headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Retrieve the token from a secure storage
        if let token = UserDefaults.standard.string(forKey: "authToken") {
            
            request.addValue("Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY2NjE3OTZlM2MwMTUzZWUzYTU1ZTVkZCIsImlhdCI6MTcxNzY3MjQyMiwiZXhwIjoxNzE4Mjc3MjIyfQ.pGofUKu2T_N66FSbNPn8C6azPWZtiN-KKmYxlmk88dI", forHTTPHeaderField: "Authorization")
        } else {
            alertMessage = "User is not authenticated. Token is missing."
            showAlert = true
            return
        }

        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                if httpResponse.statusCode == 200 {
                    return output.data
                } else {
                    let responseString = String(data: output.data, encoding: .utf8) ?? "No response body"
                    throw NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Failed to change password. Server returned status: \(httpResponse.statusCode), response: \(responseString)"])
                }
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.alertMessage = error.localizedDescription
                    self.showAlert = true
                case .finished:
                    break
                }
            }, receiveValue: { _ in
                self.alertMessage = "Password has been changed successfully."
                self.showAlert = true
            })
            .store(in: &self.cancellables)
    }
}
