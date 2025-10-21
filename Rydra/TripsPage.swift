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
    @Environment(\.dismiss) var dismiss
    @State private var showForm = false
    @State private var trips: [Trip] = []
    
    @State private var selectedTripId: UUID? = nil
    @State private var editingTripId: UUID? = nil
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.white, .orange.opacity(0.2)], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                VStack {
                    ScrollView {
                        HStack {
                            Text("Trips")
                                .bold()
                                .font(.largeTitle)
                            Spacer()
                        }
                        .padding()
                        VStack(spacing: 16) {
                            ForEach(trips) { trip in
                                ZStack(alignment: .topTrailing) {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("From: \(trip.from)")
                                        Text("To: \(trip.to)")
                                        Text("Date: \(trip.date)")
                                    }
                                    .padding()
                                    .frame(width: 320, height: 100, alignment: .leading)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.white)
                                            .shadow(radius: 5)
                                    )
                                    .padding(.horizontal)
                                    
                                    HStack {
                                        Spacer()
                                        VStack {
                                            Spacer()
                                            Button {
                                                withAnimation {
                                                    selectedTripId = (selectedTripId == trip.id) ? nil : trip.id
                                                }
                                            } label: {
                                                Image(systemName: "ellipsis")
                                                    .font(.title2)
                                                    .foregroundColor(.gray)
                                                    .padding(.trailing)
                                            }
                                            Spacer()
                                        }
                                    }
                                    .frame(width: 320, height: 100)
                                    .padding(.horizontal)
                                    
                                    if selectedTripId == trip.id {
                                        VStack(spacing: 12) {
                                            Button("Edit") {
                                                from = trip.from
                                                to = trip.to
                                                fareAmountInput = String(trip.fareAmount)
                                                distanceInput = String(trip.distance)
                                                date = trip.date
                                                
                                                editingTripId = trip.id
                                                showForm = true
                                                selectedTripId = nil
                                            }
                                            
                                            Button("Delete", role: .destructive) {
                                                if let index = trips.firstIndex(where: { $0.id == trip.id }) {
                                                    trips.remove(at: index)
                                                }
                                                selectedTripId = nil
                                            }
                                            
                                            Button("Close") {
                                                selectedTripId = nil
                                            }
                                        }
                                        .padding()
                                        .background(Color.white)
                                        .cornerRadius(10)
                                        .shadow(radius: 5)
                                        .offset(x: -20, y: -10)
                                        .zIndex(1)
                                    }
                                }
                            }
                        }
                    }
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            withAnimation {
                                resetForm()
                                showForm = true
                            }
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.black)
                        }
                        .padding()
                    }
                }
                
                if showForm {
                    VStack(spacing: 12) {
                        TextField("From", text: $from)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                        TextField("To", text: $to)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                        TextField("Fare", text: $fareAmountInput)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                        TextField("Distance", text: $distanceInput)
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
                            Button("Save") {
                                if let editingId = editingTripId,
                                   let index = trips.firstIndex(where: { $0.id == editingId }) {
                                    
                                    trips[index].from = from
                                    trips[index].to = to
                                    trips[index].date = date
                                    trips[index].fareAmount = Double(fareAmountInput) ?? 0.0
                                    trips[index].distance = Double(distanceInput) ?? 0.0
                                } else {
                                    
                                    let newTrip = Trip(
                                        from: from,
                                        to: to,
                                        date: date,
                                        fareAmount: Double(fareAmountInput) ?? 0.0,
                                        distance: Double(distanceInput) ?? 0.0
                                    )
                                    trips.append(newTrip)
                                }
                                resetForm()
                                showForm = false
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .foregroundStyle(.white)
                            .cornerRadius(10)
                            .font(.headline)
                            
                            Button("Cancel") {
                                showForm = false
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .foregroundStyle(.white)
                            .cornerRadius(10)
                            .font(.headline)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                }
            }
        }
        .navigationTitle("Trips")
        .navigationBarBackButtonHidden(true)
    }
    
    func resetForm() {
        from = ""
        to = ""
        fareAmountInput = ""
        distanceInput = ""
        date = Date()
        editingTripId = nil
    }
}

#Preview {
    TripsPage()
}
