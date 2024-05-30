//
//  TitleComponent.swift
//  BookWarden
//
//  Created by Ansh Bhasin on 29/05/24.
//

import SwiftUI

struct TitleComponent<Destination: View>: View {
    var title: String
    var page: Destination
    var body: some View {
        NavigationLink (destination: page) {
            HStack() {
                HStack() {
                    Text(title)
                    
                    Image(systemName: "chevron.right")
                }
                .foregroundStyle(.accent)
                .fontWeight(.semibold)
                .font(.title2)
                
                Spacer()
            }
            .safeAreaPadding()
        }
    }
}
