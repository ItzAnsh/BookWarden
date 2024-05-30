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
                        WishListCardView(userType: .member)
                    }
                }
                .safeAreaPadding()
                    
            }
            .scrollIndicators(.hidden)
            .navigationTitle("Wishlist")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button( action: {}) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
//                            .font(.title)
//                            .foregroundColor(.accent)
                    }
                }
            }
        }
    }
}

#Preview {
    UserWishlistView()
}
