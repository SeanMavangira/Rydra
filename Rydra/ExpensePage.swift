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
    
    @State private var expenses: [Expense] = []
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.white, .orange.opacity(0.2)], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                
                ScrollView {
                    HStack {
                        Text("Expenses")
                            .bold()
                            .font(Font.largeTitle)
                        Spacer()
                    }
                    .padding()
                    
                    VStack(alignment: .leading) {
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
                                                Text("$\(expenses.reduce(0) { $0 + $1.amountPaidInt })")
                                            }
                                            .padding(.leading, 10)
                                            
                                            Spacer()
                                            NavigationLink{
                                                ExpenseChartView_()
                                            }label:{
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
                        //.padding(.horizontal, 60)
                        .padding(.top, 10)
                        
                        
                        VStack {
                            ForEach(expenses) { expense in
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
                                    //.padding(.horizontal)
                                    
                                    // Top-right Ellipsis Button
                                    HStack {
                                        Spacer()
                                            Button {
                                                withAnimation {
                                                    selectedExpenseId = (selectedExpenseId == expense.id) ? nil : expense.id
                                                }
                                            } label: {
                                                Image(systemName: "ellipsis")
                                                    .font(.title2)
                                                    .foregroundColor(.orange)
                                                    .padding(.trailing)
                                            }
                                    }
                                    .frame(width: 320, height: 100)
                                    //.padding(.horizontal)
                                    
                                    
                                    if selectedExpenseId == expense.id {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 10)
                                                .foregroundStyle(.white)
                                                .frame(width: 100, height: 100)
                                                .shadow(radius: 5)
                                                .offset(x: -10)
                                            //.zIndex(1)
                                            VStack(spacing: 12) {
                                                Button("Edit") {
                                                    expenseName = expense.expenseName
                                                    amountPaid = expense.amountPaid
                                                    date = expense.date
                                                    
                                                    editingExpenseId = expense.id
                                                    showForm = true
                                                    selectedExpenseId = nil
                                                }
                                                
                                                Button("Delete", role: .destructive) {
                                                    if let index = expenses.firstIndex(where: { $0.id == expense.id }) {
                                                        expenses.remove(at: index)
                                                    }
                                                    selectedExpenseId = nil
                                                }
                                                
                                                Button("Close") {
                                                    selectedExpenseId = nil
                                                }
                                            }
                                            .offset(x: -15)
                                            
                                        }
                                    }
                                }
                            }
                            
                            
                        }
                    }
                }
                
                VStack {
                    //                    Spacer()
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
                                    
                                    
                                    Button {
                                        if let editingId = editingExpenseId,
                                               let index = expenses.firstIndex(where: { $0.id == editingId }) {
                                                
                                                expenses[index] = Expense(id: editingId, expenseName: expenseName, amountPaid: amountPaid, date: date)
                                            } else {
                                             
                                                let newExpense = Expense(expenseName: expenseName, amountPaid: amountPaid, date: date)
                                                expenses.append(newExpense)
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
                                            .font(.headline)
                                        
                                        
                                    }
                                }
                                Button {
                                    showForm = false
                                }label:{
                                    Text("Cancel")
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.orange)
                                        .foregroundStyle(.white)
                                        .cornerRadius(10)
                                        .font(.headline)
                                }
                                
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    }
                }
                
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
    
    func resetForm(){
        expenseName = ""
        amountPaid = ""
    }
}

#Preview {
    ExpensePage()
}
