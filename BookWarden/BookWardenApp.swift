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
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    @ObservedObject var userManager = UserManager.shared
    var userType: UserTypeForApp = .member
    
    var body: some Scene {
        WindowGroup {
            VStack {
                if userManager.accessToken != "" || UserDefaults.standard.string(forKey: "accessToken") != "" {
                    if userManager.role == "user" || UserDefaults.standard.string(forKey: "role") == "user" {
                        UserView()
//                            .preferredColorScheme(isDarkMode ? .dark : .light)
                    } else if userManager.role == "librarian" || UserDefaults.standard.string(forKey: "role") == "librarian"  {
                        LibrarianView()
//                            .preferredColorScheme(isDarkMode ? .dark : .light)
                    } else if userManager.role == "admin" || UserDefaults.standard.string(forKey: "role") == "admin" {
                        AdminHomeView()
//                            .preferredColorScheme(isDarkMode ? .dark : .light)
                    } else {
                        Login()
//                            .preferredColorScheme(isDarkMode ? .dark : .light)
                    }
                } else {
                    Login()
//                        .preferredColorScheme(isDarkMode ? .dark : .light)
                }
            }
//            .preferredColorScheme(isDarkMode ? .dark : .light)
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
