//
//  TitleComponent.swift
//  BookWarden
//
//  Created by Ansh Bhasin on 29/05/24.
//

import SwiftUI

struct TitleComponent: View {
    var title: String
    var body: some View {
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

#Preview {
    TitleComponent(title: "Title")
}
