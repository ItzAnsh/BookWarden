//
//  AdminEditLibrarySubView.swift
//  BookWarden
//
//  Created by Manan Gupta on 06/06/24.
//

import SwiftUI

struct AdminEditLibrarySubView: View {
    @Binding var id: String
    @Binding var name: String
    @Binding var location: String
    @Binding var contactEmail: String
    @Binding var contactNo: String
    @Binding var issuePeriod: Int
    @Binding var maxBooks: Int
    @Binding var fineInterest: Int
    @Binding var librarianEmail: String
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject var libraryManager = LibraryManager.shared
    @State private var showAlert = false
    @State private var emailAlert = false
    @State private var alertMessage = ""
    
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Library Details")) {
                    TextField("Enter Library name", text: $name)
                        .autocorrectionDisabled(true)
                    TextField("Library Location", text: $location)
                        .autocorrectionDisabled(true)
                }
                
                Section(header: Text("Contact Details")) {
                    TextField("Library Email", text: $contactEmail)
                        .autocorrectionDisabled(true)
                        .autocapitalization(.none)
                    TextField("Library Contact Number", text: $contactNo)
                        .keyboardType(.numberPad)
                }
                Section() {
                    HStack {
                        Text("Issue Period")
                        Spacer()
                        TextField("Enter days", text: Binding<String>(
                            get: { String(issuePeriod) },
                            set: { issuePeriod = Int($0) ?? 0 }
                        ))
                            .frame(width: 90)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                    }
                    HStack {
                        Text("Issued Books Limit")
                        Spacer()
                        TextField("Qty.", text: Binding<String>(
                            get: { String(maxBooks) },
                            set: { maxBooks = Int($0) ?? 0 }
                        ))
                            .frame(width: 90)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                    }
                    HStack {
                        Text("Per Day Fine")
                        Spacer()
                        TextField("Enter amount", text: Binding<String>(
                            get: { String(fineInterest) },
                            set: { fineInterest = Int($0) ?? 0 }
                        ))
                            .frame(width: 110)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                    }
                }
                Section(header: Text("Librarian")) {
                    TextField("Enter Librarian Email", text: $librarianEmail)
                        .autocorrectionDisabled(true)
                        .autocapitalization(.none)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Cancel")
                    }
                    .foregroundStyle(.blue)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        if isValidEmail(contactEmail) && isValidEmail(librarianEmail){
                            saveLibrary()
                        }
                        else{
                            emailAlert = true
                        }
                    }) {
                        Text("Done")
                    }
                    .foregroundStyle(.blue)
                }
            }
            .toolbarBackground(Color(.systemGray6))
            .toolbarBackground(.visible)
            .navigationTitle("Edit Library Details")
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .alert(isPresented: $emailAlert) {
                Alert(title: Text("Invalid Email"),message: Text("Please enter a valid email address."),dismissButton: .default(Text("OK")))
            }
        }
    }
    
    
    private func saveLibrary() {
        let updatedDetails = LibraryCreateBody(name: name, location: location, contactNo: contactNo, contactEmail: contactEmail, totalBooks: 0, librarianEmail: librarianEmail, maxBooks: maxBooks, issuePeriod: issuePeriod, fineInterest: fineInterest)
        
        libraryManager.updateLibrary(libraryId: id, updatedDetails: updatedDetails, accessToken: UserManager.shared.accessToken) { result in
            switch result {
            case .success:
                presentationMode.wrappedValue.dismiss()
                print("Library details updated successfully")
            case .failure(let error):
                showAlert = true
                alertMessage = error.localizedDescription
            }
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
}
