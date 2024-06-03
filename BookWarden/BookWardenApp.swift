import SwiftUI

enum UserTypeForApp {
    case member
    case librarian
    case admin
}

@main
struct BookWardenApp: App {
    @AppStorage("isOnboarding") var isOnboarding: Bool = false
    @AppStorage("authToken") var authToken: String = ""
    
    @ObservedObject var userManager = UserManager.shared
    var userType: UserTypeForApp = .member
    
    var body: some Scene {
        WindowGroup {
            if userManager.accessToken != "" {
                if userManager.role == "user" {
                    UserView()
                } else if userManager.role == "librarian" {
                    LibrarianView()
                } else if userManager.role == "admin" {
                    AdminHomeView()
                }
            } else {
                Login()
            }
        }
    }
    
    private func endEditing() {
        UIApplication.shared.endEditing()
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
