//
//  SingleLibraryRequestView.swift
//  BookWarden
//
//  Created by Manan Gupta on 07/06/24.
//

import SwiftUI

struct SingleLibraryRequestView: View {
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
        HStack() {
            VStack(alignment:.leading){
                Spacer()
                Text(title)
                    .lineLimit(1)
                    .fontWeight(.medium)
                    .font(.system(size: 15))
                Spacer()
                Text(location)
                    .lineLimit(1)
                    .font(.system(size: 15))
                Spacer()
                .sheet(isPresented: $modalState) {
                    AdminEditLibrarySubView(id: $id, name: $title, location: $location, contactEmail: $contactEmail, contactNo: $contactNo, issuePeriod: $issuePeriod, maxBooks: $maxBooks, fineInterest: $fineInterest, librarianEmail: $librarianEmail)
                }
                .padding(.horizontal)
            }
            Spacer()
            Text(Image(systemName: "chevron.right"))
                .foregroundStyle(Color.blue)
                .font(.system(size: 19))
                .padding(.horizontal)
        }
        .frame(width: 330, height: 30)
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(15)
    }

}

#Preview {
    SingleLibraryRequestView()
}
