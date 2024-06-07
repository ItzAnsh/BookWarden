//
//  FinesView.swift
//  ProfileScreen
//
//  Created by Abhi  on 30/05/24.
//
import Foundation
import SwiftUI

struct FinesView: View {
    var fines: [Fine]
    
    init(fines: [Fine]) {
        self.fines = fines
    }
    var body: some View {
        NavigationStack {
            ScrollView {
                ForEach((fines), id: \.self) { fine in
                    BookFineCard(image: fine.issueId.getBookId().imageURL, name: fine.issueId.getBookId().title, finePerDay: Int(fine.interest), numberOfDays: 20, libraryName: "Some Name")
                }
            }
            .navigationTitle("Fines")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


