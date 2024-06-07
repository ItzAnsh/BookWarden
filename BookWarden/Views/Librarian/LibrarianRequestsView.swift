//
//  LibrarianRequestsView.swift
//  BookWarden
//
//  Created by Ansh Bhasin on 31/05/24.
//

import SwiftUI

struct LibrarianRequestsView: View {
    @State private var showAlert = false // State variable to manage alert visibility
    
    @State private var showRejectAlert = false
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            ScrollView { // ScrollView to make the entire list scrollable
                VStack {
                    ForEach(0..<5) { _ in // ForEach to create five cards
                        VStack(alignment: .leading) {
                            Text("Katie")
                                .foregroundStyle(.textPrimaryColors)
                                .font(.system(size: 17))
                                .fontWeight(.bold)

                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach(0..<5) { _ in
                                        VStack {}
                                            .frame(width: 104, height: 126)
                                            .background(.red.gradient)
                                            .cornerRadius(12)
                                    }
                                }
                            }
                            .scrollIndicators(.hidden)

                            HStack {
                                Button(action: {
                                    showAlert = true // Set showAlert to true when the button is clicked
                                }) {
                                    Text("REJECT")
                                        .font(.system(size: 12))
                                        .frame(width: 50, height: 10)
                                }
                                .padding()
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .background(.blue)
                                .cornerRadius(.infinity)
                                .frame(width: 100, height: 10)

                                Spacer()

                                Button(action: {
                                    showRejectAlert = true
                                }) {
                                    Text("ACCEPT")
                                        .font(.system(size: 12))
                                        .frame(width: 50, height: 10)
                                }
                                .padding()
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .background(.blue)
                                .cornerRadius(.infinity)
                                .padding(.horizontal)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 242 / 255, green: 242 / 255, blue: 247 / 255))
                        .cornerRadius(12)
                        .padding(.horizontal) // Adding horizontal padding
                        .padding(.vertical, 5) // Adding vertical padding
                    }
                }
            }
            .scrollIndicators(.hidden)
            .navigationBarTitle(Text("Requests"))
            
            .alert("Books rejected successfully", isPresented: $showAlert) { // Define the alert
                Button("Done", role: .cancel) { }
                    
            }
            .searchable(text: $searchText)
            .alert("Books issued successfully", isPresented: $showRejectAlert) {
                Button("Done", role: .cancel) { }
            
        }
        
        }
    }
}

#Preview {
    LibrarianRequestsView()
}
