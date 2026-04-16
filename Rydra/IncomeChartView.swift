//
//  IncomechartView.swift
//  Rydra
//
//  Created by Sean Mavangira on 27/10/2025.
//

import SwiftUI
import Charts

struct IncomeChartView: View {
    @ObservedObject var viewerModel: IncomeViewModel
    @State private var selectedPeriod = "Day"
    
    private let periods = ["Day", "Week", "Month"]
    
    var body: some View {
        ZStack {
            
            
            VStack {
                // Period Picker
                Picker("Period", selection: $selectedPeriod) {
                    ForEach(periods, id: \.self) { period in
                        Text(period)
                    }
                }
                .shadow(radius: 5)
                .pickerStyle(.segmented)
                .padding()
                
                // --- THE CHART CARD ---
                VStack(alignment: .leading, spacing: 12) {
                    Text("\(selectedPeriod)ly Income")
                        .font(.headline)
                        .foregroundStyle(.black)
                    
                    Chart {
                        if selectedPeriod == "Day" {
                            ForEach(groupedByDay, id: \.0) { (weekday, total) in
                                BarMark(
                                    x: .value("Day", weekday),
                                    y: .value("Total", total)
                                )
                                .foregroundStyle(.orange.gradient) // Consistent with Expense Chart
                                .cornerRadius(6)
                            }
                        } else if selectedPeriod == "Week" {
                            ForEach(groupedByWeek, id: \.0) { (week, total) in
                                BarMark(
                                    x: .value("Week", week),
                                    y: .value("Total", total)
                                )
                                .foregroundStyle(.green.gradient)
                                .cornerRadius(6)
                            }
                        } else if selectedPeriod == "Month" {
                            ForEach(groupedByMonth, id: \.0) { (month, total) in
                                BarMark(
                                    x: .value("Month", month),
                                    y: .value("Total", total)
                                )
                                .foregroundStyle(.blue.gradient)
                                .cornerRadius(6)
                            }
                        }
                    }
                    .frame(height: 300)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .shadow(radius: 5)
                )
                .padding(.horizontal)
                
                Spacer() // Pushes the card and picker to the top
            }
        }
        .navigationTitle("Income Analytics")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // Logic for Daily grouping 
    var groupedByDay: [(String, Int)] {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        let grouped = Dictionary(grouping: viewerModel.incomes) { formatter.string(from: $0.date) }
        let order = ["Sun","Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        return grouped
            .map { ($0.key, $0.value.reduce(0) { $0 + $1.amountPaid }) }
            .sorted { (lhs, rhs) in
                let leftIdx = order.firstIndex(of: lhs.0) ?? 0
                let rightIdx = order.firstIndex(of: rhs.0) ?? 0
                return leftIdx < rightIdx
            }
    }
    
    // Logic for Weekly grouping
    var groupedByWeek: [(String, Int)] {
        let grouped = Dictionary(grouping: viewerModel.incomes) { income -> String in
            let components = Calendar.current.dateComponents([.weekOfYear, .yearForWeekOfYear], from: income.date)
            return "Wk \(components.weekOfYear ?? 0)"
        }
        return grouped
            .map { ($0.key, $0.value.reduce(0) { $0 + $1.amountPaid }) }
            .sorted(by: { $0.0 < $1.0 })
    }
    
    // Logic for Monthly grouping
    var groupedByMonth: [(String, Int)] {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        let grouped = Dictionary(grouping: viewerModel.incomes) { formatter.string(from: $0.date) }
        return grouped
            .map { ($0.key, $0.value.reduce(0) { $0 + $1.amountPaid }) }
            .sorted(by: { $0.0 < $1.0 })
    }
}

