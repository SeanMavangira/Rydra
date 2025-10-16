import SwiftUI

struct WelcomePage: View {
    let fullText = "Welcome to Rydra"
    @State private var displayedText = ""
    @State private var animate = false

    var body: some View {
        NavigationStack{
            ZStack{
                
                LinearGradient(colors: [.white, .orange.opacity(0.2)], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                VStack {
                    Image("Image 1")
                        .resizable()
                        .frame(width: 360, height: 300)
                        .cornerRadius(20)
                        .offset(y: -100)
                    
                    
                    Text(displayedText)
                        .font(.largeTitle)
                        .foregroundColor(.black)
                        .bold()
                        .shadow(color: .white.opacity(0.6), radius: 10)
                        .multilineTextAlignment(.center)
                        .opacity(animate ? 1 : 0.8)
                        .scaleEffect(animate ? 1.02 : 1.0)
                        .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: animate)
                        .onAppear {
                            animate = true
                            typeText()
                        }
                }
                NavigationLink{
                    SignIn()
                }label: {
                    ZStack{
                        
                        RoundedRectangle(cornerRadius: 16)
                            .frame(width: 150, height: 50)
                        
                            .foregroundStyle(.orange)
                        Text("Next")
                            .bold()
                            .foregroundStyle(.white)
                            .font(.title2)
                    }
                    
                }
                .offset(y: 300)
            }
        }
    }
    private func typeText() {
        displayedText = ""
        var delay = 0.0
        for letter in fullText {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    displayedText.append(letter)
                }
            }
            delay += 0.05
        }
    }
}

#Preview {
   WelcomePage()
}
