//
//  LibrarianView.swift
//  BookWarden
//
//  Created by Ansh Bhasin on 31/05/24.
//

import SwiftUI

enum LibrarianTabBar {
    case Stats
    case Requests
    case Catalogue
    case Users
}

struct LibrarianView: View {
    @State private var selection: LibrarianTabBar = .Stats
    var body: some View {
        TabView(selection: $selection) {
            LibrarianStatsView()
                .tabItem { Label("Stats", systemImage: "chart.line.uptrend.xyaxis") }
                .tag(LibrarianTabBar.Stats)
            
            LibrarianRequestsView()
                .tabItem { Label("Requests", systemImage: "person.text.rectangle.fill")}
                .tag(LibrarianTabBar.Requests)
            
            LibrarianCatalogueView()
                .tabItem { Label("Catalogue", systemImage: "books.vertical.circle") }
                .tag(LibrarianTabBar.Catalogue)
            
            LibrarianUsersView()
                .tabItem { Label("Users", systemImage: "person.fill") }
                .tag(LibrarianTabBar.Users)
        }
    }
}

#Preview {
    LibrarianView()
}
