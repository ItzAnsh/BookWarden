import SwiftUI

struct LibrarianAddUserDetailsView: View {
    @State private var nameInput = ""
    @State private var emailInput = ""
    @State private var isShowingAlert = false
    @State private var alertMessage = ""
    @Environment(\.presentationMode) var presentationMode
    var addUserCompletion: ((String, String) -> Void)?

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("ADD USER")) {
                    TextField("Name", text: $nameInput)
                        .autocapitalization(.none)

                    TextField("Email", text: $emailInput)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                }
            }
            .navigationTitle("Add User")
            .navigationBarItems(trailing: Button("Done") {
                if nameInput.isEmpty || emailInput.isEmpty {
                    isShowingAlert = true
                    alertMessage = "Please enter both name and email."
                } else {
                    addUserCompletion?(nameInput, emailInput)
                    presentationMode.wrappedValue.dismiss()
                }
            })
            .alert(isPresented: $isShowingAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}

