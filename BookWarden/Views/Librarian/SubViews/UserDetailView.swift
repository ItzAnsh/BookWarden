//
//  UserDetailView.swift
//  StatesLearning
//
//  Created by Vibho Sharma on 05/06/24.
//

import SwiftUI

struct UserDetailView: View {
    let userMail: String
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Circle()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.gray.opacity(0.2))
                
                VStack(alignment: .leading) {
                    Text(userMail)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("CUIET")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            .padding()
            .background(Color.black)
            .cornerRadius(10)
            
            NavigationLink(destination: IssuedBooks()) {
                HStack {
                    Image(systemName: "book.fill")
                    Text("Issued books")
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .padding()
                .background(Color.black)
                .cornerRadius(10)
            }
            .foregroundColor(.white)
            
            NavigationLink(destination: UserFinesView()) {
                HStack {
                    Text("Fines")
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .padding()
                .background(Color.black)
                .cornerRadius(10)
            }
            .foregroundColor(.white)
            
            Spacer()
        }
        .padding()
        .background(Color(UIColor.systemGray6).edgesIgnoringSafeArea(.all))
        .navigationTitle("User")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    // Block action
                }) {
                    Text("Block")
                        .foregroundColor(.red)
                }
            }
            ToolbarItem(placement: .principal) {
                HStack {
                    Spacer()
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                    Spacer()
                }
            }
        }
//        .preferredColorScheme(.dark)
    }
}

#Preview {
    UserDetailView(userMail: "User")
}
