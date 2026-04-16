import SwiftUI

struct Trip: Identifiable {
    let id = UUID()
    var from: String
    var to: String
    var date: Date
    var fareAmount: Double
    var distance: Double
}

struct TripsPage: View {
    @State private var from = ""
    @State private var to = ""
    @State private var fareAmountInput = ""
    @State private var distanceInput = ""
    @State private var date = Date()
    
    @State private var showForm = false
    @State private var trips: [Trip] = []
    @State private var editingTripId: UUID? = nil
    
    var body: some View {
        NavigationStack {
            ZStack {
               
                
                VStack(spacing: 0) {
                    HStack {
                        Text("Trips")
                            .font(.largeTitle)
                            .bold()
                        Spacer()
                    }
                    .padding()

                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(trips) { trip in
                                tripCard(trip)
                            }
                        }
                        .padding()
                    }
                }
                
                // Floating Action Button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            resetForm()
                            showForm = true
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 56, height: 56)
                                .foregroundColor(.orange)
                                .background(Circle().fill(.white))
                                .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
                        }
                        .padding()
                    }
                }
            }
     
            .sheet(isPresented: $showForm) {
                NavigationStack {
                    Form {
                        Section("Trip Details") {
                            TextField("From", text: $from)
                            TextField("To", text: $to)
                        }
                        
                        Section("Payment & Date") {
                            TextField("Fare Amount", text: $fareAmountInput)
                                .keyboardType(.decimalPad)
                            
                            DatePicker(
                                "Date",
                                selection: $date,
                                in: Date()...,
                                displayedComponents: .date
                            )
                        }
                    }
                    .navigationTitle(editingTripId == nil ? "Add Trip" : "Edit Trip")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") { showForm = false }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button(editingTripId == nil ? "Save" : "Update") {
                                saveTrip()
                                showForm = false
                            }
                            .disabled(from.isEmpty || to.isEmpty || fareAmountInput.isEmpty)
                        }
                    }
                }
                .presentationDetents([.medium])
            }
        }
    }

    
    @ViewBuilder
    func tripCard(_ trip: Trip) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(trip.date, style: .date)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("$\(trip.fareAmount, specifier: "%.2f")")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.orange)
                }
                Spacer()
                
                Menu {
                    Button("Edit", systemImage: "pencil") { editTrip(trip) }
                    Button("Delete", systemImage: "trash", role: .destructive) {
                        trips.removeAll { $0.id == trip.id }
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.title3)
                        .foregroundStyle(.orange)
                }
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 8) {
                    Circle().fill(.green).frame(width: 8, height: 8)
                    Text("From: \(trip.from)").font(.subheadline)
                }
                HStack(spacing: 8) {
                    Circle().fill(.red).frame(width: 8, height: 8)
                    Text("To: \(trip.to)").font(.subheadline).bold()
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 16).fill(Color.white))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }

    func saveTrip() {
        let fare = Double(fareAmountInput) ?? 0.0
        if let editingId = editingTripId,
           let index = trips.firstIndex(where: { $0.id == editingId }) {
            trips[index].from = from
            trips[index].to = to
            trips[index].date = date
            trips[index].fareAmount = fare
        } else {
            trips.append(Trip(from: from, to: to, date: date, fareAmount: fare, distance: 0.0))
        }
        resetForm()
    }

    func editTrip(_ trip: Trip) {
        from = trip.from
        to = trip.to
        fareAmountInput = String(trip.fareAmount)
        date = trip.date
        editingTripId = trip.id
        showForm = true
    }

    func resetForm() {
        from = ""
        to = ""
        fareAmountInput = ""
        date = Date()
        editingTripId = nil
    }
}




#Preview {
    TripsPage()
}
