//
//  IncomePage.swift
//  Rydra
//
//  Created by Sean Mavangira on 21/10/2025.
//

import SwiftUI

struct IncomePage: View {
    @State private var showForm = false
    @State private var incomeName = ""
    @State private var date = Date()
    @State private var amountPaid = ""
    var body: some View {
        ZStack{
            LinearGradient(colors: [.white, .orange.opacity(0.2)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack{
                
                if showForm{
                    VStack {
                        TextField("Income name", text: $incomeName)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                        
                        TextField("Amount paid", text: $amountPaid)
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
                        HStack{
                            Button{
                                
                            }label: {
                                Text("Save")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.orange)
                                    .foregroundStyle(.white)
                                    .cornerRadius(10)
                                    .font(.headline)
                            }
                            Button{
                                showForm = false
                            }label: {
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
            Button{
                showForm = true
            }label: {
                VStack{
                    Spacer()
                    HStack{
                        Spacer()
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
#Preview {
    IncomePage()
}
