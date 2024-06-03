//
//  AdminHomeView.swift
//  BookWarden
//
//  Created by Ansh Bhasin on 27/05/24.
//

import SwiftUI

enum AdminTabs {
    case Stats
    case Libraries
}

struct AdminHomeView: View {
    @State private var selection: AdminTabs = .Libraries
    var body: some View {
        VStack {
            TabView(selection: $selection) {
                AdminLibrariesView()
                    .tabItem{Label("Libraries", systemImage: "book.fill")}
                    .tag(AdminTabs.Libraries)
                
                AdminStatsView()
                    .tabItem {
                        Label("Stats", systemImage: "chart.line.uptrend.xyaxis")
                    }
                
            }
        }
    }
}

#Preview {
    AdminHomeView()
}
