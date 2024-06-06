import SwiftUI

struct PasswordChangeView: View {
    @StateObject private var viewModel = PasswordChangeViewModel()

    var body: some View {
        VStack {
            SecureField("Old Password", text: $viewModel.oldPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("New Password", text: $viewModel.newPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField("Confirm Password", text: $viewModel.confirmPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: viewModel.changePassword) {
                Text("Change Password")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding()
        }
        .padding()
        .navigationBarTitle("Change Password")
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Password Change"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}

struct PasswordChangeView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordChangeView()
    }
}
