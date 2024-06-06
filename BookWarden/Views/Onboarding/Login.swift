import SwiftUI
//import KeychainAccess

enum Field {
    
    case password
    case emailAddress
}

struct Login: View {
    @State private var email = ""
    @State private var password = ""
    @State private var loginError: String?
//    let text = KeyChainWrapper.standard.string(forKey: "authToken") ?? ""
    
    @FocusState private var focusedField: Field?
    
    @Environment(\.colorScheme) var colorScheme
    
//    @AppStorage("authToken") private var authToken = ""
//    @State private var accessToken: String = ""
    
//    @State private var authToken: String = ""
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(Color.accentColor)
                    .frame(width: 225, height: 225)
                    .blur(radius: 150)
                
                VStack {
                    Spacer()
                    VStack {
                        Image(systemName: "book.fill")
                            .foregroundColor(Color.primary)
                            .font(.system(size: 93))
                        
                        Text("BookWarden")
                            .foregroundColor(Color.primary)
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 20) {
                        VStack(spacing: 10) {
                            HStack {
                                Image(systemName: "envelope.fill")
                                    .foregroundColor(Color.primary)
                                    .font(.headline)
                                
                                TextField("Email", text: $email)
                                    .focused($focusedField, equals: .emailAddress)
                                    .textContentType(.emailAddress)
                                    .submitLabel(.next)
                                    .padding(.vertical, 1)
                                    .font(.subheadline)
                            }
                            Divider()
                            HStack {
                                Image(systemName: "lock.fill")
                                    .foregroundColor(Color.primary)
                                    .font(.headline)
                                
                                SecureField("Password", text: $password)
                                    .focused($focusedField, equals: .password)
                                    .textContentType(.password)
                                    .submitLabel(.join)
                                    .padding(.vertical, 1)
                                    .font(.subheadline)
                            }
                        }
                        .padding()
                        .background(colorScheme == .light ? Color.white : Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    
                    Button(action: {
                        login(email: email, password: password)
                    }) {
                        Text("Login")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(colorScheme == .light ? .white : .black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.accentColor)
                            .cornerRadius(8)
                    }
                    
                    if let loginError = loginError {
                        Text(loginError)
                            .foregroundColor(.red)
                            .padding()
                    }
                    
                    HStack {
                        Spacer()
                        Text("Forgot Password")
                            .font(.subheadline)
                            .foregroundColor(Color.accentColor)
                    }
                    .frame(maxWidth: .infinity)
                    
                    Spacer()
                    
                    Text("Apple collects your data in app, which is not associated with your Apple ID, in order to improve and personalise the App.")
                        .font(.caption2)
                        .foregroundColor(Color.secondary)
                }
            }
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func login(email: String, password: String) {
        let tokenResponse = UserManager.shared.loginUser(email: email, password: password) { result in
            print(result)
            switch result {
            case .success(let userRes):
                if userRes.success {
                    // Handle successful login
                    //                    authToken =
                    print("Login successful: \(userRes.user)")
                    
                } else {
                    // Handle unsuccessful login
                    self.loginError = userRes.message
                }
            case .failure(let error):
                // Handle error
                self.loginError = error.localizedDescription
            }
        }
        
        guard let TokenResp = tokenResponse else {
            return
        }
        
        if TokenResp.token != "" {
            
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
