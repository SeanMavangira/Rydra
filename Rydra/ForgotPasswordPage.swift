//
//  ForgotPasswordPage.swift
//  Rydra
//
//  Created by Sean Mavangira on 5/11/2025.
//

import SwiftUI

struct ForgotPasswordPage: View {
    @State private var username: String = ""
    @State private var isPasswordVisible = false
    @State private var isOtherPasswordVisible = false
    @State private var password = ""
    @State private var showAlert = false
    @State private var navigateToLogin = false
    var body: some View {
        NavigationStack{
            ZStack{
                LinearGradient(colors: [.white, .orange.opacity(0.5)], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                VStack{
                    HStack{
                        Text("Forgot Password")
                            .bold()
                            .font(.largeTitle)
                            .padding()
                        Spacer()
                    }
                    Spacer()
                }
                
                VStack{
                  
                    
                    Text("Create a new password")
                        .bold()
                    HStack {
                        TextField("Username", text: $username)

                         Image(systemName: "person.fill")
                             .foregroundColor(.gray)
                    }
                    .padding(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black, lineWidth: 1)
                    )
                    .padding()
                    
                    HStack {
                        Group {
                            if isPasswordVisible {
                                TextField("New Password", text: $password)
                            } else {
                                SecureField("New Password", text: $password)
                            }
                        }
                        
                        
                        Button(action: {
                            isPasswordVisible.toggle()
                        }) {
                            Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black, lineWidth: 1)
                    )
                    .padding()
                    
                    Button{
                       showAlert = true
                    }label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .frame(width: 150, height: 50)
                                .foregroundStyle(.orange)
                            
                            Text("Create")
                                .bold()
                                .foregroundStyle(.white)
                                .font(.title2)
                        }
                    }
                    .offset(y: 30)
                }
                NavigationLink(destination: SignIn(), isActive: $navigateToLogin) {
                                        EmptyView()
                                    }
                .alert("Confirmation Needed", isPresented: $showAlert) {
                            Button("OK") { // Default behavior, just dismisses
                                navigateToLogin = true
                            }
                        } message: {
                            Text("Are you sure you want to proceed with creation?")
                        }
            }
//            .navigationTitle("Forgot Password")
        }
       
    }
}

#Preview {
    ForgotPasswordPage()
}
