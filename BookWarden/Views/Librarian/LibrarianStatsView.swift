//
//  LibrarianHomeView.swift
//  BookWarden
//
//  Created by Ansh Bhasin on 27/05/24.
//

import SwiftUI

struct LibrarianStatsView: View {
    var body: some View {
        
        
        VStack(alignment: .leading, spacing: 3.0){
            HStack{
                Librarycart()
                Spacer()
                Librarycart()
            }
            Divider()
            HStack{
                Librarycart()
                Spacer()
                Librarycart()
            }
            Divider()
            Librarycart()
            
            ZStack(alignment: .topLeading) {
                Color.white
                    .ignoresSafeArea()
                VStack(alignment: .trailing) {
                    Text("Library details")
                        .font(.title)
                        .foregroundColor(.black)
                    HStack {
                        Text("Total users:")
                            .foregroundColor(.black)
                        Text("3689")
                            .foregroundColor(.black)
                    }
                    .padding(.trailing, 8)
                    HStack {
                        Text("Total books:")
                            .foregroundColor(.black)
                        Text("550")
                            .foregroundColor(.black)
                    }
                    HStack {
                        Text("Total books issued:")
                            .foregroundColor(.black)
                        Text("3690")
                            .foregroundColor(.black)
                    }
                }
                .padding()
            }
        }
    }
    
    
    
}
    
    #Preview {
        LibrarianStatsView()
    }

