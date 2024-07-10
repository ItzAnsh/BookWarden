//
//  AdminAddLibrarySubView.swift
//  BookWarden
//
//  Created by Ansh Bhasin on 03/06/24.
//
import SwiftUI

struct AdminAddLibrarySubView: View {
    @State private var name: String = ""
    @State private var location = ""
    @State private var contactEmail = ""
    @State private var contactNo = ""
    @State private var issuePeriod = ""
    @State private var maxBooks = ""
    @State private var fineInterest = ""
    @State private var librarianEmail = ""
    
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
                        TextField("Enter days", text: $issuePeriod)
                            .frame(width: 90)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                    }
                    HStack {
                        Text("Issued Books Limit")
                        Spacer()
                        TextField("Qty.", text: $maxBooks)
                            .frame(width: 90)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                    }
                    HStack {
                        Text("Per Day Fine")
                        Spacer()
                        TextField("Enter amount", text: $fineInterest)
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
            .navigationTitle("Add Library Details")
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .alert(isPresented: $emailAlert) {
                Alert(title: Text("Invalid Email"),message: Text("Please enter a valid email address."),dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func createLibraryRequestBody() -> LibraryCreateBody? {
        guard let issuePeriodInt = Int(issuePeriod), let maxBooksInt = Int(maxBooks), let fineInterestInt = Int(fineInterest) else {
            alertMessage = "Please enter valid numerical values for Issue Period, Max Books, and Fine Interest."
            showAlert = true
            return nil
        }
        
        return LibraryCreateBody(
            name: name,
            location: location,
            contactNo: contactNo,
            contactEmail: contactEmail,
            totalBooks: 0,
            librarianEmail: librarianEmail,
            maxBooks: maxBooksInt,
            issuePeriod: issuePeriodInt,
            fineInterest: fineInterestInt
        )
    }
    
    private func saveLibrary() {
        guard let libraryRequestBody = createLibraryRequestBody() else { return }
        
        libraryManager.addLibrary(libraryRequestBody: libraryRequestBody, accessToken: UserManager.shared.accessToken) { result in
            switch result {
            case .success():
                DispatchQueue.main.async {
                    presentationMode.wrappedValue.dismiss()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    alertMessage = error.localizedDescription
                    showAlert = true
                }
            }
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
}
