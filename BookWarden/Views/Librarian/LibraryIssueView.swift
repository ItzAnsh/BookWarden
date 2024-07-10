//
//  LibraryIssueView.swift
//  BookWarden
//
//  Created by ASHU SINGHAL on 11/06/24.
//

import SwiftUI

import SwiftUI

struct LibraryIssueView: View {
    @State private var showingBottomSheet = false
    
    var body: some View {
        VStack {
            Button("Tap Me") {
                showingBottomSheet.toggle()
            }
            .buttonStyle(.borderedProminent)
        }
        .cornerRadius(12)
        .padding()
        .sheet(isPresented: $showingBottomSheet) {
            BottomSheetView(showingBottomSheet: $showingBottomSheet)
                .presentationDragIndicator(.visible)
        }
    }
}

struct BottomSheetView: View {
    @Binding var showingBottomSheet: Bool
    
    var body: some View {
        VStack {
            Text("Palak's request")
                .font(.system(size: 32, weight: .medium, design: .default))
                .frame(maxWidth: .infinity, maxHeight: 100)
            
            VStack {
                Image("i1")
                    .renderingMode(.original)
                    .resizable()
                    .frame(width: 180, height: 200)
                    .padding(.bottom, 10)
                
                VStack(spacing: 6) {
                    Text("The Great Gatsby")
                        .font(.system(size: 32, weight: .medium, design: .default))
                        .padding(.bottom,20)
                    HStack{
                        Text("Issue Date")
                            .font(.system(size: 16, weight: .medium, design: .default))
                        Spacer()
                        Text("11 June, 2024")
                            .font(.system(size: 16, weight: .medium, design: .default))
                    }
                    HStack{
                        Text("Deadline")
                            .font(.system(size: 16, weight: .medium, design: .default))
                        Spacer()
                        Text("11 August, 2024")
                            .font(.system(size: 16, weight: .medium, design: .default))
                    }
                    HStack{
                        Text("Fine")
                            .font(.system(size: 16, weight: .medium, design: .default))
                        Spacer()
                        Text("NA")
                            .font(.system(size: 16, weight: .medium, design: .default))
                    }
                }
                .safeAreaPadding()
                
                
                Spacer()
                
                HStack (spacing: 20){
                    Button {
                        showingBottomSheet.toggle()
                    } label: {
                        Text("Decline")
                            .frame(width: 140, height: 50)
                            .background(Color.blue)
                            .cornerRadius(25) // Use a fixed radius value
                            .foregroundColor(.white)
                    }
                    
                    Button {
                        showingBottomSheet.toggle()
                    } label: {
                        Text("Approve")
                            .frame(width: 140, height: 50)
                            .background(Color.blue)
                            .cornerRadius(25) // Use a fixed radius value
                            .foregroundColor(.white)
                    }
                }
            }
            Spacer()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryIssueView()
    }
}


