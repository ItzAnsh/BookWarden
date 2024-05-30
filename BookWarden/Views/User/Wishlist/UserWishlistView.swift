//
//  UserWishlistView.swift
//  BookWarden
//
//  Created by Ansh Bhasin on 27/05/24.
//

import SwiftUI

struct UserWishlistView: View {
    var body: some View {
        NavigationStack {
            ScrollView(){
                VStack(spacing: 27) {
                    ForEach(0..<10) { index in
                        WishListItemCard(userType: .member)
                    }
                }
                .safeAreaPadding()
                    
            }
            .scrollIndicators(.hidden)
            .navigationTitle("Wishlist")
        }
    }
}

#Preview {
    UserWishlistView()
}
