import SwiftUI

struct AdminLibrariesView: View {
    @State var searchText = ""
    @State var modalState: Bool = false
    
    @ObservedObject var libraryManager = LibraryManager.shared
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(libraryManager.libraries) { library in
                        SingleLibraryView(title: library.getName(), location: library.getLocation())
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
//
//struct SingleLibraryView: View {
//    var library: Library
//    
//    var body: some View {
//        VStack(alignment: .leading) {
//            Text(library.name)
//                .font(.headline)
//            Text(library.location)
//                .font(.subheadline)
//            // Add other details as necessary
//        }
//        .padding()
//        .background(Color(.secondarySystemBackground))
//        .cornerRadius(8)
//    }
//}

#Preview {
    AdminLibrariesView()
}
