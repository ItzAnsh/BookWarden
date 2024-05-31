//
//  BookWardenApp.swift
//  BookWarden
//
//  Created by Ansh Bhasin on 22/05/24.
//

import SwiftUI

@main
struct BookWardenApp: App {
    @AppStorage("isOnboarding") var isOnboarding: Bool = false
    @AppStorage("userType") var userType: String = ""
    @AppStorage("authToken") var authToken: String = ""
    var body: some Scene {
        WindowGroup {
            if authToken != "" {
                UserView()
            } else {
                Login()
            }
        }
    }
}
