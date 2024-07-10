//
//  FinesView.swift
//  ProfileScreen
//
//  Created by Abhi  on 30/05/24.
//
import Foundation
import SwiftUI

struct FinesView: View {
    @ObservedObject var userManager = UserManager.shared
//    var fines: [Fine]
//    
//    init(fines: [Fine]) {
//        self.fines = fines
//    }
    var body: some View {
        NavigationStack {
            ScrollView {
                ForEach((userManager.user?.getFines() ?? []), id: \.self) { fine in
                    BookFineCard(image: fine.issueId.getBook().imageURL, name: fine.issueId.getBook().title, finePerDay: Int(fine.interest), numberOfDays: 20, libraryName: "Some Name")
                }
            }
            .navigationTitle("Fines")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


