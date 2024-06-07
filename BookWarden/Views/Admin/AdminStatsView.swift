//
//  AdminStatsView.swift
//  BookWarden
//
//  Created by Ansh Bhasin on 03/06/24.
//

import SwiftUI

struct AdminStatsView: View {
    @State private var selectedSegment = 0
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack{
                    VStack {
                        Picker("Options", selection: $selectedSegment) {
                            Text("1D").tag(0)
                            Text("1W").tag(1)
                            Text("1M").tag(2)
                            Text("1Y").tag(3)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding()
                    }
                    HStack(){
                        Text("Request")
                            .padding(.horizontal)
                            .fontWeight(.semibold)
                            .font(.system(size: 19))
                        Spacer()
                    }
                    .padding(.horizontal)
                    SingleLibraryRequestView()
                    SingleLibraryRequestView()
                    SingleLibraryRequestView()
                }
            }
            .navigationTitle("Stats")
        }
    }
}

#Preview {
    AdminStatsView()
}
