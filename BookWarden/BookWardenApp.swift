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
    var body: some Scene {
        WindowGroup {
            UserView()
        }
    }
}
