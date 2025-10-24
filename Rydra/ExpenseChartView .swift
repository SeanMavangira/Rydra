//
//  ExpenseChartView .swift
//  Rydra
//
//  Created by Sean Mavangira on 24/10/2025.
//

import SwiftUI
import Charts
struct ExpenseData: Identifiable{
    var id = UUID()
    var amount: Double
    var days: String
    var weeks: String
    var months : String
}

struct ExpenseChartView_: View {
    @State private var expenses: [Expense] = []
    var body: some View {
        Chart{
//            ForEach(expenses) { expenses in
//                BarMark(x: <#T##PlottableValue<Plottable>#>, y: <#T##PlottableValue<Plottable>#>)
//            }
        }
    }
}

#Preview {
    ExpenseChartView_()
}
