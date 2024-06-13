import SwiftUI

struct LibrarianUsersView: View {
    @ObservedObject var viewModel = UserManager.shared
    @State private var searchText = ""
    @State private var isPresentingAddUserView = false

    var filteredUsers: [AllUserResponse] {
        if searchText.isEmpty {
            return viewModel.allUsers
        } else {
            return viewModel.allUsers.filter { $0.email.localizedCaseInsensitiveContains(searchText) }
        }
    }

    var groupedUsers: [String: [AllUserResponse]] {
        Dictionary(grouping: filteredUsers, by: { String($0.email.prefix(1)) })
    }

    var sortedKeys: [String] {
        groupedUsers.keys.sorted { $0.localizedCaseInsensitiveCompare($1) == .orderedAscending }
    }

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(sortedKeys, id: \.self) { key in
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
                .sheet(isPresented: $isPresentingAddUserView, content: {
                    LibrarianAddUserDetailsView(addUserCompletion: { emails in
                        addUsers(emails: emails)
                    })
                })
            }
            .onAppear {
                viewModel.fetchAllUsers()
            }
        }
    }

    func usersInSection(for key: String) -> some View {
        ForEach(groupedUsers[key] ?? [], id: \.email) { user in
            NavigationLink(destination: UserDetailView(userMail: user.email)) {
                VStack(alignment: .leading) {
                    Text(user.email)
                        .padding(.vertical, 0)
                }
            }
        }
    }

    func addUsers(emails: [String]) {
        for email in emails {
            viewModel.addUser(userMail: email) { success in
                if success {
                    // If user is successfully added, fetch all users again to refresh the list
                    viewModel.fetchAllUsers()
                } else {
                    // Handle failure to add user
                    // You can show an alert or handle it based on your requirement
                }
            }
        }
    }
}
