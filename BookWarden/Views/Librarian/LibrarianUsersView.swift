import SwiftUI

struct LibrarianUsersView: View {
    @ObservedObject var viewModel = UserManager.shared
    @State private var searchText = ""
    @State private var isPresentingAddUserView = false
    @State private var users: [AllUserResponse] = []

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
            .listStyle(PlainListStyle())
            .navigationTitle("Users")
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isPresentingAddUserView = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isPresentingAddUserView) {
                LibrarianAddUserDetailsView(addUserCompletion: { name, email in
                    addUser(name: name, email: email)
                })
            }
        }
        .onAppear {
            viewModel.fetchAllUsers()
        }
    }

    func usersInSection(for key: String) -> some View {
        ForEach(groupedUsers[key]!, id: \.self) { user in
            NavigationLink(destination: UserDetailView(userName: user.name)) {
                VStack(alignment: .leading) {
                    Text(user.email)
                        .padding(.vertical, 0)
                }
            }
        }
    }

    func addUser(name: String, email: String) {
        viewModel.addUser(name: name, email: email) { success in
            if success {
                // If user is successfully added, update the list of users
                let newUser = AllUserResponse(_id: UUID().uuidString, name: name, email: email, password: "", role: "", date: "")
                users.append(newUser)
            } else {
                // Handle failure to add user
                // You can show an alert or handle it based on your requirement
            }
        }
    }
}
