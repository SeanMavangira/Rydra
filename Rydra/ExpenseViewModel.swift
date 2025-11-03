//
//  ExpenseViewModel.swift
//  Rydra
//
//  Created by Sean Mavangira on 3/11/2025.
//

import SwiftUI
import Combine

class ExpenseViewModel: ObservableObject {
    @Published var expenses: [Expense] = []
    
    var totalExpenses: Int {
        expenses.reduce(0) { $0 + $1.amountPaidInt }
    }
}

