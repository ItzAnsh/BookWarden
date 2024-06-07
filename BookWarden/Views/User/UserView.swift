//
//  UserView.swift
//  BookWarden
//
//  Created by Ansh Bhasin on 28/05/24.
//

import SwiftUI

enum UserTab {
    case Home
    case Library
    case Wishlist
    case Profile
}


struct UserView: View {
    
    @State private var selection: UserTab = .Home
    var body: some View {
        TabView(selection: $selection) {
            UserHomeView()
                .tabItem { Label("Home", systemImage: "house.fill") }
                .tag(UserTab.Home)
            
            UserLibraryView()
                .tabItem { Label("Library", systemImage: "book.fill") }
                .tag(UserTab.Library)
            
            UserWishlistView()
                .tabItem { Label("Wishlist", systemImage: "heart.fill") }
                .tag(UserTab.Wishlist)
            
            UserProfileView()
                .tabItem { Label("Profile", systemImage: "person.fill") }
                .tag(UserTab.Profile)
        }
    }
}

#Preview {
    UserView()
}
