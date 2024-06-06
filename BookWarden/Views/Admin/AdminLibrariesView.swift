import SwiftUI

struct AdminLibrariesView: View {
    @State var searchText = ""
    @State var modalState: Bool = false
    @StateObject var libraryManager = LibraryManager.shared
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(libraryManager.libraries) { library in
                        SingleLibraryView(id: library.getId(), title: library.getName(), location: library.getLocation(), contactNo: library.getContactNo(),contactEmail: library.getContactEmail(),issuePeriod: library.getIssuePeriod(),maxBooks: library.getMaxBooks(),fineInterest: library.getFineInterest(), librarianEmail: library.getLibrarian().getEmail())
                    }
                }
                .padding(.horizontal)
                .navigationTitle("Libraries")
                .searchable(text: $searchText)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                        modalState = true
                        }) {
                            Image(systemName: "plus")
                        }
                        .foregroundStyle(.blue)
                    }
                }
            }
            .sheet(isPresented: $modalState) {
                AdminAddLibrarySubView()
            }
        }
        .onAppear {
            libraryManager.fetchLibraries(accessToken: UserManager.shared.accessToken) { result in
                switch result {
                case .success(let libraries):
                    print("Libraries fetched successfully: \(libraries)")
                case .failure(let error):
                    print("Error fetching libraries: \(error)")
                }
            }
        }
    }
}

#Preview {
    AdminLibrariesView()
}
