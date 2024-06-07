//
//  FinesView.swift
//  StatesLearning
//
//  Created by Vibho Sharma on 05/06/24.
//

import SwiftUI

struct UserFinesView: View {
    var body: some View {
        NavigationStack {
            
            List {
                ForEach((0..<3), id: \.self) { _ in
                    FinesViewCard()
                }
            }
            .listStyle(.grouped)
            .navigationBarTitle("Fines", displayMode: .inline)
            
        }
        
        
    }
}

#Preview {
    UserFinesView()
}
