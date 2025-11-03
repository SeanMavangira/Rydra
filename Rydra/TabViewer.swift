//
//  TabView.swift
//  Rydra
//
//  Created by Sean Mavangira on 21/10/2025.
//

import SwiftUI

import SwiftUI

struct TabViewer: View {
    var body: some View {
        NavigationStack{
            TabView {
                ExpensePage(viewModel: ExpenseViewModel())
                    .tabItem {
                        Label("Expenses", systemImage: "chart.bar.xaxis.descending")
                    }
                TripsPage()
                    .tabItem {
                        Label("Trips", systemImage: "car.fill")
                    }
                IncomePage()
                    .tabItem {
                        Label("Income", systemImage: "chart.bar.xaxis.ascending")
                    }
                
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}



#Preview {
    TabViewer()
}
