////
////  IssueRequestModal.swift
////  BookWarden
////
////  Created by ASHU SINGHAL on 11/06/24.
////
//
//import SwiftUI
//
//struct IssueRequestModalView: View {
//    
//    var body: some View {
//        VStack {
//            Text("Palak's request")
//                .font(.system(size: 32, weight: .medium, design: .default))
//                .frame(maxWidth: .infinity, maxHeight: 100)
//            
//            VStack {
//                Image("BookImageShould render using Async")
//                    .renderingMode(.original)
//                    .resizable()
//                    .frame(width: 180, height: 200)
//                    .padding(.bottom, 10)
//                
//                VStack(spacing: 6) {
//                    Text("Book Namey")
//                        .font(.system(size: 32, weight: .medium, design: .default))
//                        .padding(.bottom,20)
//                    HStack{
//                        Text("Issue Date")
//                            .font(.system(size: 16, weight: .medium, design: .default))
//                        Spacer()
//                        Text("Enter Issue data here")
//                            .font(.system(size: 16, weight: .medium, design: .default))
//                    }
//                    Divider()
//                    HStack{
//                        Text("Deadline")
//                            .font(.system(size: 16, weight: .medium, design: .default))
//                        Spacer()
//                        Text("Enter Deadline here")
//                            .font(.system(size: 16, weight: .medium, design: .default))
//                    }
//                    Divider()
//                    HStack{
//                        Text("Status")
//                            .font(.system(size: 16, weight: .medium, design: .default))
//                        Spacer()
//                        Text("Enter status here")
//                            .font(.system(size: 16, weight: .medium, design: .default))
//                    }
//                    Divider()
//                }
//                .safeAreaPadding()
//                
//                
//                Spacer()
//                
//                HStack (spacing: 20){
//                    Button {
//                    } label: {
//                        Text("Decline")
//                            .frame(width: 140, height: 50)
//                            .background(Color.blue)
//                            .cornerRadius(25) // Use a fixed radius value
//                            .foregroundColor(.white)
//                    }
//                    
//                    Button {
//                    } label: {
//                        Text("Approve")
//                            .frame(width: 140, height: 50)
//                            .background(Color.blue)
//                            .cornerRadius(25) // Use a fixed radius value
//                            .foregroundColor(.white)
//                    }
//                }
//            }
//            Spacer()
//        }
//        .padding()
//    }
//}
