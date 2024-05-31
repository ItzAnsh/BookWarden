//
//  Login.swift
//  BookWarden
//
//  Created by Ansh Bhasin on 30/05/24.
//

import SwiftUI

struct Login: View {
    @State var email = ""
    @State var password = ""
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        VStack {
            
            ZStack() {
                Circle()
                    .fill(.accent)
                    
                    .frame(width: 225, height: 225)
                    .blur(radius: 150)
                VStack {
                    Spacer()
                    VStack() {
                        Image(systemName: "book.fill")
                            .foregroundColor(.textPrimaryColors)
                            .font(.system(size: 93))
                        
                        Text("BookWarden")
                            .foregroundStyle(.blackNAccent)
                            .font(.title)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    }
                    
                    Spacer()
                    VStack(spacing: 20) {
                        VStack(spacing: 10) {
                            HStack() {
                                Image(systemName: "envelope.fill")
                                    .foregroundColor(.textPrimaryColors)
                                    .font(.title3)
                                
                                TextField("Email", text: $email)
                                    .padding(.vertical, 1)
                                    
                            }
                            Divider()
                            HStack() {
                                Image(systemName: "lock.fill")
                                    .foregroundColor(.textPrimaryColors)
                                    .font(.title3)
                                
                                TextField("Passowrd", text: $password)
                                    .padding(.vertical, 1)
                            }
                        }
                        .background(colorScheme == .light ? .white : Color(red: 28 / 255, green: 28 / 255, blue: 30 / 255))
                        .safeAreaPadding(.all)
                        .cornerRadius(12)
                    }
                    
                    Button(action: {}) {
                        Text("Login")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(.textTertiaryColors)
                    }
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    .padding(.vertical, 12)
                    .background(.accent)
                    .cornerRadius(8)
                    
                    HStack() {
                        Spacer()
                        Text("Forgot Password")
                            .font(.subheadline)
                            .foregroundStyle(.accent)
                    }
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    
                    Spacer()
                    
                    Text("Apple collects your data in app, which is not associated with your Apple ID, in order to improve and personalise the App.")
                        .font(.caption)
                        .foregroundStyle(.textSecondaryColors)
                
                }
                
            }
//            .safeAreaPadding()
            
            
//            .background(.black)
//            .shadow(color: .accent, radius: 50 , x: 0, y: 0)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
//        .edgesIgnoringSafeArea(.all)
        .padding(.horizontal)
    }
}

#Preview {
    Login()
}
