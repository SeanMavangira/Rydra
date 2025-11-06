//
//  SignUp.swift
//  Rydra
//
//  Created by Sean Mavangira on 16/10/2025.
//
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
        NavigationStack{
            ZStack{
                LinearGradient(colors: [.white, .orange.opacity(0.5)], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                VStack{
                    
                    Text("Rydra")
                        .font(.system(size: 60, weight: .bold, design: .rounded))
                        .kerning(2)
                        .foregroundColor(.black)
                        .shadow(color: .gray.opacity(0.3), radius: 2, x: 0, y: 2)
                        .offset(y: -50)
                    
                    Text("Create account")
                        .font(.system(size: 20).weight(.heavy))
                        .foregroundStyle(.black)
                    
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
                    
                    HStack{
                        TextField("Email", text: $email)
                        
                        Image(systemName: "mail.fill")
                            .foregroundStyle(.gray)
                        
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black, lineWidth: 1)
                    )
                    .padding()
                    if !email.isEmpty && !isEmailValid(email){
                        Text("Email is not valid")
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                    
                    HStack {
                        Group {
                            if isPasswordVisible {
                                TextField("Password", text: $password)
                            } else {
                                SecureField("Password", text: $password)
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
                    if !username.isEmpty && !password.isEmpty && hasLetter && hasNumber && password.count >= 8 && isEmailValid(email){
                        
                        
                        NavigationLink {
                            TabViewer()
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
                        .offset(y: 100)
                    }
                }
                
            }
        }
    }
}
#Preview {
    SignUp()
}
