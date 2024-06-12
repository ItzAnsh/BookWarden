//
//  LibrarianHomeView.swift
//  BookWarden
//
//  Created by Ansh Bhasin on 27/05/24.
//

import SwiftUI
import Foundation

struct LibrarianStatsView: View {
    @State private var selectedSegment = 1
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Picker(selection: $selectedSegment, label: Text("Picker"), content: {
                        Text("1D").tag(1)
                        Text("1W").tag(2)
                        Text("1M").tag(3)
                        Text("1Y").tag(4)
                    })
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(width: 350)
                    .padding(.horizontal)
                    .padding(.top)
                }
                
                VStack(alignment: .leading, spacing: 3.0) {
                    if selectedSegment == 1 {
                        segmentContent(
                            title: "Daily Stats",
                            totalUsers: "3689",
                            totalBooks: "550",
                            totalBooksIssued: "3690",
                            cartValues: [
                                (percentage: 15, heading: "Total Users", image: "person.circle.fill", value: 3689),
                                (percentage: 24, heading: "Books Issued", image: "book.closed", value: 1200),
                                (percentage: 8, heading: "Fine collected", image: "indianrupeesign", value: 2048),
                                (percentage: 7, heading: "Fine pending", image: "indianrupeesign", value: 2200),
                                (percentage: 14, heading: "Issue requests", image: "book.pages", value: 2048)
                            ]
                        )
                    } else if selectedSegment == 2 {
                        segmentContent(
                            title: "Weekly Stats",
                            totalUsers: "3700",
                            totalBooks: "560",
                            totalBooksIssued: "3705",
                            cartValues: [
                                (percentage: 16, heading: "Total Users", image: "person.circle.fill", value: 3700),
                                (percentage: 25, heading: "Books Issued", image: "book.closed", value: 1210),
                                (percentage: 9, heading: "Fine collected", image: "indianrupeesign", value: 2050),
                                (percentage: 8, heading: "Fine pending", image: "indianrupeesign", value: 2205),
                                (percentage: 15, heading: "Issue requests", image: "book.pages", value: 2050)
                            ]
                        )
                    } else if selectedSegment == 3 {
                        segmentContent(
                            title: "Monthly Stats",
                            totalUsers: "3750",
                            totalBooks: "600",
                            totalBooksIssued: "3800",
                            cartValues: [
                                (percentage: 17, heading: "Total Users", image: "person.circle.fill", value: 3750),
                                (percentage: 26, heading: "Books Issued", image: "book.closed", value: 1220),
                                (percentage: 10, heading: "Fine collected", image: "indianrupeesign", value: 2060),
                                (percentage: 9, heading: "Fine pending", image: "indianrupeesign", value: 2210),
                                (percentage: 16, heading: "Issue requests", image: "book.pages", value: 2060)
                            ]
                        )
                    } else if selectedSegment == 4 {
                        segmentContent(
                            title: "Yearly Stats",
                            totalUsers: "4000",
                            totalBooks: "700",
                            totalBooksIssued: "4500",
                            cartValues: [
                                (percentage: 18, heading: "Total Users", image: "person.circle.fill", value: 4000),
                                (percentage: 27, heading: "Books Issued", image: "book.closed", value: 1300),
                                (percentage: 11, heading: "Fine collected", image: "indianrupeesign", value: 2100),
                                (percentage: 10, heading: "Fine pending", image: "indianrupeesign", value: 2300),
                                (percentage: 17, heading: "Issue requests", image: "book.pages", value: 2100)
                            ]
                        )
                    }
                }
            }
            .navigationTitle("Stats")
        }
    }
    
    @ViewBuilder
    private func segmentContent(title: String, totalUsers: String, totalBooks: String, totalBooksIssued: String, cartValues: [(percentage: Int, heading: String, image: String, value: Int)]) -> some View {
        VStack(alignment: .leading, spacing: 3.0) {
            HStack {
                Spacer()
                Librarycart(Percentage: cartValues[0].percentage, Heading: cartValues[0].heading, image: cartValues[0].image, Value: cartValues[0].value)
                Spacer()
                Librarycart(Percentage: cartValues[1].percentage, Heading: cartValues[1].heading, image: cartValues[1].image, Value: cartValues[1].value)
                Spacer()
            }
            .padding(.bottom, 12)
            .padding(.top)
            HStack {
                Spacer()
                Librarycart(Percentage: cartValues[2].percentage, Heading: cartValues[2].heading, image: cartValues[2].image, Value: cartValues[2].value)
                Spacer()
                Librarycart(Percentage: cartValues[3].percentage, Heading: cartValues[3].heading, image: cartValues[3].image, Value: cartValues[3].value)
                Spacer()
            }
            .padding(.bottom, 12)
            Librarycart(Percentage: cartValues[4].percentage, Heading: cartValues[4].heading, image: cartValues[4].image, Value: cartValues[4].value)
                .padding(.leading)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.title)
                    .foregroundColor(.black)
                HStack {
                    Text("Total users:")
                        .font(.custom("Helvetica Neue", size: 18))
                        .foregroundColor(.black)
                    Spacer()
                    Text(totalUsers)
                        .foregroundColor(.blue)
                }
                .frame(width: 350, height: 31)
                .padding(.trailing, 8)
                
                HStack {
                    Text("Total books:")
                        .font(.custom("Helvetica Neue", size: 18))
                        .foregroundColor(.black)
                    Spacer()
                    Text(totalBooks)
                        .foregroundColor(.blue)
                }
                .frame(width: 350, height: 31)
                
                HStack {
                    Text("Total books issued:")
                        .font(.custom("Helvetica Neue", size: 18))
                        .foregroundColor(.black)
                    Spacer()
                    Text(totalBooksIssued)
                        .foregroundColor(.blue)
                }
                .frame(width: 350, height: 31)
            }
            .padding()
        }
    }
}

#Preview {
    LibrarianStatsView()
}
