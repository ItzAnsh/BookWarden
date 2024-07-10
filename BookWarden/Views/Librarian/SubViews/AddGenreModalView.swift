//
//  AddGenreModalView.swift
//  BookWarden
//
//  Created by Manan Gupta on 11/06/24.
//

import SwiftUI

struct AddGenreModalView: View {
    var body: some View {
        NavigationStack{
            Text("HELLO")
            .navigationTitle("Genre")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button (action: {
                        //                        modalState = false
                    }) {
                        Text("Back")
                            .foregroundStyle(.blue)
                    }
                }
                
                
                ToolbarItem(placement: .topBarTrailing)  {
                        Text("Next")
                            .foregroundStyle(.blue)
                }
            }
            .toolbarBackground(.visible)
        }
    }
}

#Preview {
    AddGenreModalView()
}
