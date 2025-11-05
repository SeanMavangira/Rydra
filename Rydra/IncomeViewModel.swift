//
//  IncomeViewModel.swift
//  Rydra
//
//  Created by Sean Mavangira on 5/11/2025.
//

import Foundation
import Combine

class IncomeViewModel: ObservableObject {
    @Published  var incomes: [Income] = []
    
    var totalIncome: Int {
        incomes.reduce(0) { $0 + $1.amountPaid }
    }
}
