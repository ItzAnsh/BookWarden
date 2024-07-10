import SwiftUI

struct LibrarianAddUserDetailsView: View {
    @State private var emailInput = ""
    @State private var emailList = [String]()
    @State private var invalidEmails = [String]()
    @State private var isShowingAlert = false
    @State private var alertMessage = ""
    @Environment(\.presentationMode) var presentationMode
    var addUserCompletion: (([String]) -> Void)?
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("ADD USERS")) {
                        Text("Enter emails separated by spaces")
                        VStack {
                            TextEditor(text: $emailInput)
                                .frame(height: 100)
                                .cornerRadius(5)
                                .padding(.horizontal)
                                .onChange(of: emailInput) { newValue in
                                    handleEmailInput(newValue)
                                }
                        }
                    }
                    
                    if !invalidEmails.isEmpty {
                        Section(header: Text("INVALID EMAILS")) {
                            List {
                                ForEach(invalidEmails, id: \.self) { email in
                                    Text(email)
                                        .foregroundColor(.red)
                                        .font(.body)
                                }
                            }
                        }
                    }
                    
                    if !emailList.isEmpty {
                        Section(header: Text("ENTERED EMAILS")) {
                            List {
                                ForEach(emailList, id: \.self) { email in
                                    HStack {
                                        Text(email)
                                            .lineLimit(nil)
                                        Spacer()
                                        Button(action: {
                                            removeEmail(email)
                                        }) {
                                            Image(systemName: "minus.circle.fill")
                                                .foregroundColor(.red)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Add Users")
                .navigationBarItems(trailing: Button("Done") {
                    finalizeEmails()
                })
                .alert(isPresented: $isShowingAlert) {
                    Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }
        }
    }
    
    private func handleEmailInput(_ newValue: String) {
        // Split input into individual emails
        let emails = newValue.components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }
        
        // Clear lists before processing
        invalidEmails.removeAll()
        emailList.removeAll()
        
        for email in emails {
            if isValidEmail(email) {
                emailList.append(email)
            } else {
                invalidEmails.append(email)
            }
        }
    }
    
    private func removeEmail(_ email: String) {
        if let index = emailList.firstIndex(of: email) {
            emailList.remove(at: index)
        }
    }
    
    private func finalizeEmails() {
        if emailList.isEmpty {
            isShowingAlert = true
            alertMessage = "Please enter valid emails."
        } else {
            addUserCompletion?(emailList)
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: email)
    }
}

struct LibrarianAddUserDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        LibrarianAddUserDetailsView(addUserCompletion: { _ in })
    }
}





//import SwiftUI
//
//struct LibrarianAddUserDetailsView: View {
//    @State private var emailInputs = [String]()
//    @State private var newEmail = ""
//    @State private var isShowingAlert = false
//    @State private var alertMessage = ""
//    @Environment(\.presentationMode) var presentationMode
//    var addUserCompletion: (([String]) -> Void)?
//
//    var body: some View {
//        NavigationView {
//            Form {
//                Section(header: Text("ADD USERS")) {
//                    Text("Enter emails below")
//                    
//                    ForEach(0..<emailInputs.count, id: \.self) { index in
//                        HStack {
//                            TextField("Email \(index + 1)", text: Binding(
//                                get: { self.emailInputs[index] },
//                                set: { self.emailInputs[index] = $0 }
//                            ))
//                            .autocapitalization(.none)
//                            .keyboardType(.emailAddress)
//                            
//                            Button(action: {
//                                self.emailInputs.remove(at: index)
//                            }) {
//                                Image(systemName: "minus.circle.fill")
//                                    .foregroundColor(.red)
//                            }
//                        }
//                    }
//                    
//                    HStack {
//                        TextField("New Email", text: $newEmail)
//                            .autocapitalization(.none)
//                            .keyboardType(.emailAddress)
//                            .frame(width: 300, height: 100)
//                        Button(action: {
//                            if !self.newEmail.isEmpty {
//                                self.emailInputs.append(self.newEmail)
//                                self.newEmail = ""
//                            }
//                        }) {
//                            Image(systemName: "plus.circle.fill")
//                                .foregroundColor(.green)
//                        }
//                    }
//                }
//            }
//            .navigationTitle("Add Users")
//            .navigationBarItems(trailing: Button("Done") {
//                let emails = emailInputs.filter { !$0.isEmpty }
//                if emails.isEmpty {
//                    isShowingAlert = true
//                    alertMessage = "Please enter at least one email."
//                } else {
//                    addUserCompletion?(emails)
//                    presentationMode.wrappedValue.dismiss()
//                }
//            })
//            .alert(isPresented: $isShowingAlert) {
//                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
//            }
//        }
//    }
//}
