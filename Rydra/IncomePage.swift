import SwiftUI
struct Income: Identifiable{
    var id = UUID()
    var amountPaid: Int
    var date: Date
}
struct IncomePage: View {
    @State private var showForm = false
    @State private var incomeName = ""
    @State private var date = Date()
    @State private var amountPaidInput = ""
    @State private var incomes: [Income] = []
    @State private var selectedIncomeId: UUID? = nil
    @State private var editingIncomeId: UUID? = nil
    
    var body: some View {
        NavigationStack{
            ZStack {
                
                LinearGradient(colors: [.white, .orange.opacity(0.2)],
                               startPoint: .top,
                               endPoint: .bottom)
                .ignoresSafeArea()
                
             
                
                ScrollView{
                    HStack{
                        
                        Text("Incomes")
                            .bold()
                            .font(Font.largeTitle)
                        Spacer()
                    }
                    .padding()
                    VStack {
                        HStack {
                            VStack(alignment: .leading, spacing: 16) {
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(width: 200, height: 100)
                                    .foregroundStyle(.white)
                                    .shadow(radius: 16)
                                    .overlay(
                                        HStack {
                                            VStack(alignment: .leading) {
                                                Text("Total Income:")
                                                    .bold()
                                                Text("$\(incomes.reduce(0) { $0 + $1.amountPaid })")
                                                
                                            }
                                            .padding(.leading, 10)
                                            
                                            Spacer()
                                            NavigationLink{
                                               
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
                            Spacer()
                        }
                        //.padding(.horizontal, 40)
                        .padding(.top, 10)
                        ForEach(incomes) { income in
                            HStack {
                                ZStack (alignment: .topTrailing){
                                    VStack(alignment: .leading, spacing: 8) {
                                        //                    Text("Income Name: \(income.incomeName)")
                                        Text("Amount made: \(income.amountPaid)")
                                        Text("Date: \(income.date.formatted(date: .abbreviated, time: .omitted))")
                                    }
                                    .padding()
                                    .frame(width: 320, height: 100, alignment: .leading)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.white)
                                            .shadow(radius: 5)
                                    )
                                    //.padding(.horizontal)
                                    
                                    if selectedIncomeId == income.id {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 10)
                                                .foregroundStyle(.white)
                                                .frame(width: 100, height: 100)
                                                .shadow(radius: 5)
                                                .offset(x: -1)
                                            //.zIndex(1)
                                            VStack(spacing: 12) {
                                                Button("Edit") {
                                                    
                                                    amountPaidInput = String(income.amountPaid)
                                                    
                                                    date = income.date
                                                    
                                                    editingIncomeId = income.id
                                                    showForm = true
                                                    selectedIncomeId = nil
                                                }
                                                
                                                Button("Delete", role: .destructive) {
                                                    if let index = incomes.firstIndex(where: { $0.id == income.id }) {
                                                        incomes.remove(at: index)
                                                    }
                                                    //                                            selectedIncomeId = nil
                                                }
                                                
                                                Button("Close") {
                                                    selectedIncomeId = nil
                                                }
                                            }
                                            .offset(x: -2)
                                        }
                                    }
                                    if selectedIncomeId != income.id{
                                        HStack{
                                            Spacer()
                                            Button{
                                                withAnimation{
                                                    editingIncomeId = nil
                                                    selectedIncomeId = (selectedIncomeId == income.id) ? nil : income.id
                                                }
                                            }label: {
                                                Image(systemName: "ellipsis")
                                                    .font(.title2)
                                                    .foregroundColor(.orange)
                                                    .padding(.trailing)
                                            }
                                        }
                                        .frame(width: 320, height: 100)
                                        //.padding(.horizontal)
                                    }
                                    Spacer()
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 40)
                }
                if showForm {
                    VStack(spacing: 16) {
                        //                    TextField("Income name", text: $incomeName)
                        //                        .padding()
                        //                        .overlay(
                        //                            RoundedRectangle(cornerRadius: 10)
                        //                                .stroke(Color.black, lineWidth: 1)
                        //                        )
                        
                        TextField("Amount made", text: $amountPaidInput)
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
                            Button{
                                if let editingId = editingIncomeId,
                                   let index = incomes.firstIndex(where: { $0.id == editingId}){
                                    incomes[index] = Income(id: editingId, amountPaid: Int(amountPaidInput) ?? 0, date: date)
                                    
                                    amountPaidInput = ""
                                    showForm = false
                                }else{
                                    
                                    let newIncome = Income(
                                        amountPaid: Int(amountPaidInput) ?? 0,
                                        date: date
                                    )
                                    
                                    incomes.append(newIncome)
                                    amountPaidInput = ""
                                    showForm = false
                                }
                            } label:{
                                Text("Save")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.orange)
                                .foregroundStyle(.white)
                                .cornerRadius(10)
                                .font(.headline)
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
                    .frame(maxHeight: .infinity)
                }
                
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            withAnimation {
                                showForm = true
                            }
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .foregroundStyle(.black)
                                .frame(width: 50, height: 50)
                        }
                        .padding()
                    }
                }
                
            }
        }
    }
}

#Preview {
    IncomePage()
}
