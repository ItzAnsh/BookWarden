//
//  LibrarianUsersView.swift
//  BookWarden
//
//  Created by Ansh Bhasin on 31/05/24.
//

import SwiftUI

struct LibrarianUsersView: View {
    @ObservedObject var viewModel = UserManager.shared
    @State private var searchText = ""
    @State private var selectedUserName: String? = nil
    
    var filteredUsers: [AllUserResponse] {
        if searchText.isEmpty {
            return viewModel.allUsers
        } else {
            return viewModel.allUsers.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var groupedUsers: [String: [AllUserResponse]] {
        Dictionary(grouping: filteredUsers, by: { String($0.name.prefix(1)) })
    }
    var body: some View {
        NavigationStack {
            List {
                ForEach(groupedUsers.keys.sorted(), id: \.self) { key in
                    Section(header: Text(key)
                        .foregroundColor(.gray)
                        .font(.headline)) {
                            usersInSection(for: key)
                        }
                }
            }
//            .edgesIgnoringSafeArea(.all)
            .listStyle(PlainListStyle())
            .navigationTitle("Users")
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            
        }
        
//        .preferredColorScheme(.dark) // Ensure the app is always in dark mode
        .onAppear {
            print("Fetching users...")
            viewModel.fetchAllUsers()
        }
        
    }
    
    func usersInSection(for key: String) -> some View {
            ForEach(groupedUsers[key]!, id: \.self) { user in
                NavigationLink(destination: UserDetailView(userName: user.name)) {
                    VStack(alignment: .leading) {
                        Text(user.name)
                            .padding(.vertical, 0)
                    }
                }
            }
        }

}

#Preview {
    LibrarianUsersView()
}
