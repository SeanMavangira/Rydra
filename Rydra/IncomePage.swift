import SwiftUI
struct Income: Identifiable{
    var id = UUID()
    var amountPaid: Int
    var date: Date
}
struct IncomePage: View {
    @State private var showForm = false
    @State private var amountPaidInput = ""
    @State private var date = Date()
    @State private var editingIncomeId: UUID? = nil
    
    @ObservedObject var viewerModel: IncomeViewModel
    
   
    var totalIncome: Int {
        viewerModel.incomes.reduce(0) { $0 + $1.amountPaid }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                
                ScrollView {
                    VStack(spacing: 16) {
                        //  Total Income Card (Standardized Size)
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.white)
                                .shadow(radius: 5)
                            
                            VStack(spacing: 8) {
                                Text("Total Income")
                                    .font(.subheadline)
                                    .foregroundStyle(.gray)
                                
                                Text("$\(totalIncome)")
                                    .font(.system(size: 34, weight: .bold, design: .rounded))
                            }
                            
                            // Navigation to Chart
                            
                                HStack {
                                    Spacer()
                                    NavigationLink(destination: IncomeChartView(viewerModel: viewerModel)) {
                                        Image(systemName: "arrow.forward.circle.fill")
                                            .font(.title)
                                            .foregroundStyle(.orange)
                                            .padding(12)
                                    }
                                }
                                Spacer()
                            
                        }
                        .frame(height: 120)
                        .padding(.horizontal)
                        
                        // 2. Income List (ForEach)
                        VStack(spacing: 12) {
                            ForEach(viewerModel.incomes) { income in
                                incomeRow(income: income)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top)
                }
                
                // 3. Floating Add Button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            editingIncomeId = nil
                            amountPaidInput = ""
                            date = Date()
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
            // 4. Form as a Sheet (Matching Expense Page)
            .sheet(isPresented: $showForm) {
                NavigationStack {
                    Form {
                        Section("Income Details") {
                            TextField("Amount Made", text: $amountPaidInput)
                                .keyboardType(.decimalPad)
                            DatePicker("Date", selection: $date, in: Date()..., displayedComponents: .date)
                        }
                    }
                    .navigationTitle(editingIncomeId == nil ? "Add Income" : "Edit Income")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") { showForm = false }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button(editingIncomeId == nil ? "Save" : "Update") {
                                saveIncome()
                                showForm = false
                            }
                            .disabled(amountPaidInput.isEmpty)
                        }
                    }
                }
                .presentationDetents([.medium])
            }
        }
    }
    
    // Helper Row View
    @ViewBuilder
    func incomeRow(income: Income) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Income") // You could add an 'incomeName' field to your struct later
                    .font(.headline)
                Text(income.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            
            Spacer()
            
            HStack(spacing: 8) {
                Text("$\(income.amountPaid)")
                    .font(.callout.bold())
                
                Menu {
                    Button("Edit") {
                        editingIncomeId = income.id
                        amountPaidInput = String(income.amountPaid)
                        date = income.date
                        showForm = true
                    }
                    Button("Delete", role: .destructive) {
                        viewerModel.incomes.removeAll { $0.id == income.id }
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
        .background(RoundedRectangle(cornerRadius: 12).fill(.white))
        .shadow(radius: 5)
    }
    
    func saveIncome() {
        let amount = Int(amountPaidInput) ?? 0
        if let editingId = editingIncomeId,
           let index = viewerModel.incomes.firstIndex(where: { $0.id == editingId }) {
            viewerModel.incomes[index] = Income(id: editingId, amountPaid: amount, date: date)
        } else {
            let newIncome = Income(amountPaid: amount, date: date)
            viewerModel.incomes.append(newIncome)
        }
    }
}

#Preview {
    IncomePage(viewerModel: IncomeViewModel())
}
