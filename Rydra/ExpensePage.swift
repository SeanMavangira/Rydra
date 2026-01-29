import SwiftUI

struct Expense: Identifiable {
    var id = UUID()
    var expenseName: String
    var amountPaid: String
    var date: Date
    var amountPaidInt: Int { Int(amountPaid) ?? 0 }
}

struct ExpensePage: View {
    @State private var expenseName = ""
    @State private var showForm: Bool = false
    @State private var amountPaid = ""
    @State private var date = Date()
    @State private var selectedExpenseId: UUID? = nil
    @State private var editingExpenseId: UUID? = nil
    
    @ObservedObject var viewModel: ExpenseViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.white, .orange.opacity(0.5)], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                ScrollView {
                    HStack {
                        Text("Expenses")
                            .bold()
                            .font(.largeTitle)
                        Spacer()
                    }
                    .padding()
                    
                    VStack(alignment: .leading) {
                        //  Total Expenses Card
                        HStack {
                            VStack(alignment: .leading, spacing: 16) {
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(width: 200, height: 100)
                                    .foregroundStyle(.white)
                                    .shadow(radius: 16)
                                    .overlay(
                                        HStack {
                                            VStack(alignment: .leading) {
                                                Text("Total Expenses:")
                                                    .bold()
                                                Text("$\(viewModel.totalExpenses)")
                                            }
                                            .padding(.leading, 10)
                                            
                                            Spacer()
                                            NavigationLink {
                                                ExpenseChartView_(viewModel: viewModel)
                                            } label: {
                                                Image(systemName: "arrow.right.circle.fill")
                                                    .resizable()
                                                    .frame(width: 25, height: 25)
                                                    .font(.title3)
                                                    .padding(.trailing, 10)
                                                    .padding(.top, 5)
                                                    .foregroundStyle(.orange)
                                            }
                                        }
                                    )
                            }
                        }
                        .frame(width: 320, height: 100, alignment: .leading)
                        .padding(.top, 10)
                        
                        //  Expense List
                        VStack {
                            ForEach(viewModel.expenses) { expense in
                                ZStack(alignment: .topTrailing) {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Expense Name: \(expense.expenseName)")
                                        Text("Amount Paid: \(expense.amountPaid)")
                                        Text("Date: \(expense.date.formatted(date: .abbreviated, time: .omitted))")
                                    }
                                    .padding()
                                    .frame(width: 320, height: 100, alignment: .leading)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.white)
                                            .shadow(radius: 5)
                                    )
                                    
                                    //  Button
                                    HStack{
                                        Button {
                                            
                                            withAnimation {
                                                selectedExpenseId = (selectedExpenseId == expense.id) ? nil : expense.id
                                            }
                                        } label: {
                                            Spacer()
                                            Image(systemName: "ellipsis")
                                                .font(.title2)
                                                .foregroundColor(.orange)
                                                .padding(.trailing)
                                            
                                        }
                                        .frame(width: 320, height: 100)
                                        
                                    }
                                    // Edit/Delete Popup
                                    // Edit/Delete Popup (Perfect Alignment)
                                    if selectedExpenseId == expense.id {
                                        VStack(spacing: 0) {

                                            Button("Edit") {
                                                expenseName = expense.expenseName
                                                amountPaid = expense.amountPaid
                                                date = expense.date
                                                editingExpenseId = expense.id
                                                showForm = true
                                                selectedExpenseId = nil
                                            }
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 33)

                                            Divider()

                                            Button("Delete", role: .destructive) {
                                                if let index = viewModel.expenses.firstIndex(where: { $0.id == expense.id }) {
                                                    viewModel.expenses.remove(at: index)
                                                }
                                                selectedExpenseId = nil
                                            }
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 33)

                                            Divider()

                                            Button("Close") {
                                                selectedExpenseId = nil
                                            }
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 34)
                                        }
                                        .frame(width: 110, height: 100)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color.white)
                                                .shadow(radius: 5)
                                        )
                                        .offset(x: 0, y: 0)
                                    }

                                    
                                }
                            }
                        }
                    }
                }
                
                // Add/Edit Form
                if showForm {
                    VStack(spacing: 12) {
                        TextField("Expense name", text: $expenseName)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                        
                        TextField("Amount Paid", text: $amountPaid)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                        
                        DatePicker("Date", selection: $date, displayedComponents: .date)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                        
                        HStack {
                            if !expenseName.isEmpty && !amountPaid.isEmpty {
                                
                                
                                Button{
                                    if let editingId = editingExpenseId,
                                       let index = viewModel.expenses.firstIndex(where: { $0.id == editingId }) {
                                        viewModel.expenses[index] = Expense(
                                            id: editingId,
                                            expenseName: expenseName,
                                            amountPaid: amountPaid,
                                            date: date
                                        )
                                    } else {
                                        let newExpense = Expense(expenseName: expenseName, amountPaid: amountPaid, date: date)
                                        viewModel.expenses.append(newExpense)
                                    }
                                    showForm = false
                                    resetForm()
                                    editingExpenseId = nil
                                }label:{
                                    Text("Save")
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.orange)
                                        .foregroundStyle(.white)
                                        .cornerRadius(10)
                                }
                            }
                            Button {
                                showForm = false
                            }label:{
                                Text("Cancel")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.gray)
                                    .foregroundStyle(.white)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding()
                }
                
                // Floating Add Button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            showForm.toggle()
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .foregroundStyle(.black)
                                .frame(width: 50, height: 50)
                        }
                    }
                    .padding()
                }
            }
        }
    }
    
    func resetForm() {
        expenseName = ""
        amountPaid = ""
    }
}

#Preview {
    ExpensePage(viewModel: ExpenseViewModel())
}
