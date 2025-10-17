//
//  SignUp.swift
//  Rydra
//
//  Created by Sean Mavangira on 16/10/2025.
//
import SwiftUI

import SwiftUI

struct SignUp: View {
    func isEmailValid(_ email: String) -> Bool {
        return email.contains("@") && email.contains(".com")
    }
    let numbers = "1234567890"
    let specialChars = "!@#$%^&*()_+{}[]|'<,>.?/~"
    let letters = "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM"
    @State private var isPasswordVisible = false
    @State private var isConfirmPasswordVisible = false
    @State private var username = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var email = ""
    
    var hasLetter: Bool {
        password.contains(where: { letters.contains($0) })
    }
    
    var hasNumber: Bool {
        password.contains(where: { numbers.contains($0) })
    }
    
    var hasSpecialChar: Bool {
        password.contains(where: { specialChars.contains($0) })
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.white, .orange.opacity(0.2)], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                VStack(spacing: 16) {
                    Text("Rydra")
                        .font(.system(size: 60, weight: .bold, design: .rounded))
                        .kerning(2)
                        .foregroundColor(.black)
                        .shadow(color: .gray.opacity(0.3), radius: 2, x: 0, y: 2)
                        .offset(y: -50)
                    
                    Text("Create account")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundStyle(.black)
                        .offset(y: -15)
                    
                    
                    HStack {
                        TextField("Username", text: $username)
                            .autocapitalization(.none)
                        Image(systemName: "person.fill")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.black, lineWidth: 1))
                    .padding(.horizontal)
                    
                    
                    HStack {
                        TextField("Email", text: $email)
                            .autocapitalization(.none)
                        Image(systemName: "mail.fill")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.black, lineWidth: 1))
                    .padding(.horizontal)
                    
                    
                    if !email.isEmpty && !isEmailValid(email) {
                        Text("Invalid email.")
                            .foregroundStyle(.red)
                            .font(.caption)
                            .padding(.horizontal)
                    }
                    
                    
                    HStack {
                        if isPasswordVisible {
                            TextField("Password", text: $password)
                        } else {
                            SecureField("Password", text: $password)
                        }
                        
                        Button {
                            isPasswordVisible.toggle()
                        } label: {
                            Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.gray)
                                .frame(width: 24, height: 24)
                        }
                    }
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.black, lineWidth: 1))
                    .padding(.horizontal)
                    
                    if !hasLetter && !password.isEmpty{
                        Text("Password should contain at least one letter")
                            .foregroundColor(.red)
                            .font(.caption)
                    }else if !hasNumber && !password.isEmpty {
                        Text("Password should contain at least one Number")
                            .foregroundColor(.red)
                            .font(.caption)
                    } else if password.count < 8 &&  !password.isEmpty{
                        Text("Password should be at least 8 characters long")
                            .foregroundColor(.red)
                            .font(.caption)
                        
                    }
                    
                    HStack {
                        if isConfirmPasswordVisible {
                            TextField("Confirm Password", text: $confirmPassword)
                        } else {
                            SecureField("Confirm Password", text: $confirmPassword)
                        }
                        
                        Button {
                            isConfirmPasswordVisible.toggle()
                        } label: {
                            Image(systemName: isConfirmPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.gray)
                                .frame(width: 24, height: 24)
                        }
                    }
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.black, lineWidth: 1))
                    .padding(.horizontal)
                    
                    
                    if !confirmPassword.isEmpty {
                        Text(password == confirmPassword ? "Passwords match" : "Passwords do not match")
                            .foregroundStyle(password == confirmPassword ? .green : .red)
                            .font(.caption)
                            .padding(.horizontal)
                    }
                    
                    if !password.isEmpty && !username.isEmpty && password.count >= 8 && password == confirmPassword {
                        NavigationLink {
                            TripsPage()
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .frame(width: 150, height: 50)
                                    .foregroundStyle(.orange)
                                
                                Text("Sign Up")
                                    .bold()
                                    .foregroundStyle(.white)
                                    .font(.title2)
                            }
                        }
                        
                        .padding(.top, 30)
                    }
                }
                .padding(.vertical)
                .offset(y: 10)
                
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }
}

#Preview {
    SignUp()
}
