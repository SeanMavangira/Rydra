import SwiftUI

struct Expense: Identifiable {
    var id = UUID()
    var expenseName: String
    var amountPaid: String
    var date: Date
    var amountPaidInt: Int { Int(amountPaid) ?? 0 }
}

import SwiftUI

struct ExpensePage: View {
    @State private var expenseName = ""
    @State private var showForm: Bool = false
    @State private var amountPaid = ""
    @State private var date = Date()
    @State private var selectedExpenseId: UUID? = nil
    @State private var editingExpenseId: UUID? = nil
    
    @ObservedObject var viewModel: ExpenseViewModel
    
   
    var totalAmount: Double {
        viewModel.expenses.reduce(0) { $0 + (Double($1.amountPaid) ?? 0) }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                
                ScrollView {
                    VStack(spacing: 16) {
                        // Total Expenses Card
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.white)
                                .shadow( radius: 5)
                            
                            VStack(spacing: 8) {
                                Text("Total Amount")
                                    .font(.subheadline)
                                    .foregroundStyle(.gray)
                                
                                Text("$\(totalAmount, specifier: "%.2f")")
                                    .font(.system(size: 34, weight: .bold, design: .rounded))
                            }
                            
                            HStack {
                                        Spacer()
                                        NavigationLink(destination: ExpenseChartView_(viewModel: viewModel)) {
                                            Image(systemName: "arrow.forward.circle.fill")
                                                .font(.title)
                                                .foregroundStyle(.orange)
                                                .padding(12)
                                        }
                                    }
                        }
                        .frame(height: 120)
                        .padding(.horizontal)
                        
                        // Expense List
                        VStack(spacing: 12) {
                            ForEach(viewModel.expenses) { expense in
                                expenseRow(expense: expense)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top)
                }
                
                // Floating Add Button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            editingExpenseId = nil
                            resetForm()
                            showForm = true
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .foregroundStyle(.orange)
                                .shadow(radius: 4)
                        }
                    }
                    .padding()
                }
            }
            
            // The Sheet for Adding/Editing
            .sheet(isPresented: $showForm) {
                NavigationStack {
                    Form {
                        Section("Expense Details") {
                            TextField("Expense Name", text: $expenseName)
                            TextField("Amount Paid", text: $amountPaid)
                                .keyboardType(.decimalPad)
                            DatePicker(
                                "Date",
                                selection: $date,
                                in: Date()...,
                                displayedComponents: .date
                            )
                        }
                    }
                    .navigationTitle(editingExpenseId == nil ? "Add Expense" : "Edit Expense")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") { showForm = false }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button(editingExpenseId == nil ? "Save" : "Update") {
                                    saveExpense()
                                    showForm = false
                                }
                                .disabled(expenseName.isEmpty || amountPaid.isEmpty)
                        }
                    }
                }
                .presentationDetents([.medium])
            }
        }
    }
    
    // Helper Views
        @ViewBuilder
        func expenseRow(expense: Expense) -> some View {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(expense.expenseName)
                        .font(.headline)
                    Text(expense.date.formatted(date: .abbreviated, time: .omitted))
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
                
                Spacer()
                
                // Grouping Amount and Menu together so they stay side-by-side
                HStack(spacing: 8) {
                    Text("$\(Double(expense.amountPaid) ?? 0, specifier: "%.2f")")
                        .font(.callout.bold())
                    
                    Menu {
                        Button("Edit") {
                            prepareEdit(expense)
                        }
                        Button("Delete", role: .destructive) {
                            deleteExpense(expense)
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.title3)
                            .padding(.vertical, 8)
                            .padding(.leading, 8)
                            .foregroundStyle(.orange)
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(RoundedRectangle(cornerRadius: 12).fill(.white))
            .shadow(radius: 5)
        }
    
    // Logic
    func saveExpense() {
        
        if Calendar.current.startOfDay(for: date) < Calendar.current.startOfDay(for: Date()) {
            return
        }

        if let editingId = editingExpenseId,
           let index = viewModel.expenses.firstIndex(where: { $0.id == editingId }) {
            viewModel.expenses[index] = Expense(id: editingId, expenseName: expenseName, amountPaid: amountPaid, date: date)
        } else {
            let newExpense = Expense(expenseName: expenseName, amountPaid: amountPaid, date: date)
            viewModel.expenses.append(newExpense)
        }
        
        editingExpenseId = nil
        resetForm()
    }
    
    func prepareEdit(_ expense: Expense) {
        expenseName = expense.expenseName
        amountPaid = expense.amountPaid
        date = expense.date
        editingExpenseId = expense.id
        showForm = true
    }
    
    func deleteExpense(_ expense: Expense) {
        viewModel.expenses.removeAll { $0.id == expense.id }
    }
    
    func resetForm() {
        expenseName = ""
        amountPaid = ""
        date = Date()
    }
}

#Preview {
    ExpensePage(viewModel: ExpenseViewModel())
}
