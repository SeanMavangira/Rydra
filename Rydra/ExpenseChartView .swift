//
//  ExpenseChartView .swift
//  Rydra
//
//  Created by Sean Mavangira on 24/10/2025.
//

import SwiftUI
import Charts

struct ExpenseChartView_: View {
    @ObservedObject var viewModel: ExpenseViewModel
    @State private var selectedPeriod = "Day"
    
    private let periods = ["Day", "Week", "Month"]
    
    var body: some View {
        ZStack{
            LinearGradient(colors: [.white, .orange.opacity(0.2)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack {
                Text("Expense Chart")
                    .font(.title)
                    .bold()
                    .padding(.top)
                
                // Period Picker
                Picker("Period", selection: $selectedPeriod) {
                    ForEach(periods, id: \.self) { period in
                        Text(period)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                
                // Chart
                Chart {
                    if selectedPeriod == "Day" {
                        ForEach(groupedByDay, id: \.0) { (weekday, total) in
                            BarMark(
                                x: .value("Day", weekday),
                                y: .value("Total", total)
                            )
                            .foregroundStyle(.orange)
                        }
                    } else if selectedPeriod == "Week" {
                        ForEach(groupedByWeek, id: \.0) { (week, total) in
                            BarMark(
                                x: .value("Week", week),
                                y: .value("Total", total)
                            )
                            .foregroundStyle(.green)
                        }
                    } else if selectedPeriod == "Month" {
                        ForEach(groupedByMonth, id: \.0) { (month, total) in
                            BarMark(
                                x: .value("Month", month),
                                y: .value("Total", total)
                            )
                            .foregroundStyle(.blue)
                        }
                    }
                }
                .frame(height: 300)
                .padding()
            }
//            .navigationTitle("Expense Chart")
//            .navigationBarTitleDisplayMode(.inline)
        }
        
        
    }
    
    // Daily grouping
    var groupedByDay: [(String, Int)] {
           let formatter = DateFormatter()
           formatter.dateFormat = "EEE"
           
           let grouped = Dictionary(grouping: viewModel.expenses) { expense in
               formatter.string(from: expense.date)
           }
           
           let order = ["Sun","Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
           
           return grouped
               .map { ($0.key, $0.value.reduce(0) { $0 + $1.amountPaidInt }) }
               .sorted { (lhs, rhs) in
                   guard
                       let leftIdx = order.firstIndex(of: lhs.0),
                       let rightIdx = order.firstIndex(of: rhs.0)
                   else { return lhs.0 < rhs.0 }
                   return leftIdx < rightIdx
               }
       }
    
    
    // Weekly grouping
    var groupedByWeek: [(String, Int)] {
        let grouped = Dictionary(grouping: viewModel.expenses) { expense -> String in
            let components = Calendar.current.dateComponents([.weekOfYear, .yearForWeekOfYear], from: expense.date)
            let week = components.weekOfYear ?? 0
            let year = components.yearForWeekOfYear ?? 0
            return "Week \(week), \(year)"
        }
        
        return grouped
            .map { (key, value) in
                (key, value.reduce(0) { $0 + $1.amountPaidInt })
            }
            .sorted(by: { $0.0 < $1.0 })
    }
    
    // Monthly grouping
    var groupedByMonth: [(String, Int)] {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        let grouped = Dictionary(grouping: viewModel.expenses) { expense in
            formatter.string(from: expense.date)
        }
        return grouped
            .map { ($0.key, $0.value.reduce(0) { $0 + $1.amountPaidInt }) }
            .sorted(by: { $0.0 < $1.0 })
    }
}
