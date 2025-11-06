//
//  SettingsPage.swift
//  Rydra
//
//  Created by Sean Mavangira on 6/11/2025.
//

import SwiftUI

struct SettingsPage: View {
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(colors: [.white, .orange.opacity(0.5)], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                VStack{
                    HStack{
                        Text("Settings")
                            .font(.largeTitle)
                            .bold()
                        Spacer()
                    }
                     .padding()
                    List {
                        NavigationLink {
                            
                        } label: {
                            Text("Notifications")
                        }
                        .padding()
                        
                        NavigationLink{
                            
                        }label: {
                            Text("Appearance")
                        }
                        .padding()
                        
                        NavigationLink{
                            
                        }label: {
                            Text("Theme")
                        }
                        .padding()
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                }
                
            }
        }
        
    }
}

#Preview {
    SettingsPage()
}
