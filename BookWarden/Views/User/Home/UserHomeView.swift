//
//  UserHomeView.swift
//  BookWarden
//
//  Created by Ansh Bhasin on 27/05/24.
//

import SwiftUI

// Background gradient
var grayGradient = LinearGradient(colors: [.secondaryColors, .tertiaryColors], startPoint: .top, endPoint: .bottom)

struct UserHomeView: View {

// Start of the UI Code
    var body: some View {
        // Used to navigate on a single screen
        NavigationStack {
            // Used to make the View scrollable
            ScrollView {
                // Used to distribute elements vertically
                VStack(spacing: 20) {
                    
                    VStack(spacing: 10) {
                        // Horizontal scroll View used for horizontal scrolling
                        ScrollView(.horizontal) {
                            
                            // Used to distribute elements vertically
                            HStack(spacing: 15) {
                                ForEach((1...4), id: \.self) {_ in
                                    HomeDeadlineCard()
                                }
                            }
                            .safeAreaPadding()
                        }
                    }
                    
                    VStack(spacing: 34) {
                        UserRecommendationView()
                        
//                        TitleComponent(
                        UserHomeGenresSubView()
                        
                        VStack() {
                            TitleComponent(title: "New Arrivals", page: ArrivalBooks())
                            
                            VStack() {
                                ScrollView(.horizontal) {
                                    VStack(spacing: 19) {
                                        // Loop in frontend
                                        ForEach((0..<3), id: \.self) { _ in
                                            HStack(spacing: 26) {
                                                ArrivalCardsSubView()
                                                ArrivalCardsSubView()
                                                ArrivalCardsSubView()
                                            }
                                        }
                                    }
                                    
                                }
                                .safeAreaPadding(.horizontal)
                            }
                        }
                        .background(grayGradient)
                        
                    }
                }
            }
            .scrollIndicators(.hidden)
            .navigationTitle("Home")
            .background(
                Color(.backgroundColors)
            )
        }
//        .padding(.bottom, 48)
    }
}

#Preview {
    UserHomeView()
}
