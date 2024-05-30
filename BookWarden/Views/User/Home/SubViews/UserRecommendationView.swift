//
//  UserRecommendationView.swift
//  BookWarden
//
//  Created by Ansh Bhasin on 28/05/24.
//

import SwiftUI

struct UserRecommendationView: View {
    var images: [String] = ["https://m.media-amazon.com/images/I/81w7a13pbnL.AC_SX500.jpg", "https://m.media-amazon.com/images/I/71FSf6i6yvL.AC_SX500.jpg", "https://m.media-amazon.com/images/I/81xVpyjUC0L.AC_SX500.jpg", "https://m.media-amazon.com/images/I/71kUYNSKKgL.AC_SX500.jpg"]

    var body: some View {
        VStack(alignment: .leading) {
            TitleComponent(title: "You May Like", page: ArrivalBooks())
            
            ScrollView(.horizontal) {
                HStack(spacing: 17) {
                    ForEach((images), id: \.self) {image in
                        AsyncImage(url: URL(string: image)) {image in
                            image
                                .resizable()
                                .frame(width: 150, height: 200)
                                .scaledToFit()
                                
                        } placeholder: {}
                        
                        
                            
                    }
                }
            }
            .safeAreaPadding(.horizontal)
            .scrollIndicators(.hidden)
        }
        .background(grayGradient)
        
    }
}

#Preview {
    UserRecommendationView()
}
