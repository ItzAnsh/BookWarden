//
//  SingleLibraryView.swift
//  BookWarden
//
//  Created by Ansh Bhasin on 03/06/24.
//

import SwiftUI

struct SingleLibraryView: View {
    @State var modalState: Bool = false
    @State var id: String = "0"
    @State var title: String = "Chitkara University"
    @State var location: String = "Ground Floor, Law Block"
    @State var contactNo: String = "98222222"
    @State var contactEmail: String = "abc@gmail.com"
    @State var issuePeriod: Int = 2
    @State var maxBooks: Int = 2
    @State var fineInterest: Int = 2
    @State var librarianEmail: String = "ansh@gmail.com"
    @State private var showAlert = false

    @StateObject var libraryManager = LibraryManager.shared

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .lineLimit(1)
                .font(.title2)
                .fontWeight(.bold)

            Text(location)
                .lineLimit(1)
                .font(.caption)

            HStack {
                Button(action: {
                    modalState = true
                }) {
                    Text("EDIT")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .frame(width: 100)
                        .padding(.vertical, 8)
                        .background(.blue)
                        .cornerRadius(.infinity)
                }

                Spacer()

                Button(action: {
                    showAlert = true
                }) {
                    Text("DELETE")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .frame(width: 100)
                        .padding(.vertical, 8)
                        .background(.blue)
                        .cornerRadius(.infinity)
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Confirm Delete"),
                        message: Text("Are you sure you want to delete this library?"),
                        primaryButton: .destructive(Text("Delete")) {
                            deleteLibrary()
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
            .sheet(isPresented: $modalState) {
                AdminEditLibrarySubView(id: $id, name: $title, location: $location, contactEmail: $contactEmail, contactNo: $contactNo, issuePeriod: $issuePeriod, maxBooks: $maxBooks, fineInterest: $fineInterest, librarianEmail: $librarianEmail)
            }
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(15)
    }

    func deleteLibrary() {
        libraryManager.deleteLibrary(libraryId: id, accessToken: UserManager.shared.accessToken) { result in
            switch result {
            case .success:
                print("Library deleted successfully")
            case .failure(let error):
                print("Failed to delete library: \(error)")
            }
        }
    }
}

#Preview {
    SingleLibraryView()
}
