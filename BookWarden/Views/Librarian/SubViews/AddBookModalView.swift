//
//  AddBookModalView.swift
//  BookWarden
//
//  Created by Ansh Bhasin on 07/06/24.
//

import SwiftUI

struct AddBookModalView: View {
    @State var ISBN: String = ""
    @State var bookName: String = ""
    @State var bookAuthor: String = ""
    @State var genre: String = ""
    @State var language: String = ""
    @State var publisher: String = ""
    @State var length: Int = 0
    @State var ISBN10: String = ""
    @State var ISBN13: String = ""
    
    var body: some View {
        NavigationView {
            List {
                Section("CREATE FROM ISBN") {
                    Text("ISBN")
                    TextField("ISBN", text: $ISBN)
                }
            }
        }
    }
}

#Preview {
    AddBookModalView()
}
