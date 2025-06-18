import SwiftUI

struct HomeView: View {
    @AppStorage("selectedTab") private var selectedTab = "home"
    @State private var animate = false
    
    @State private var currentImage = 0
    @State private var fadeIn = false
    private let mealImages = ["meal1", "meal2", "meal3", "meal4", "meal5", "meal6"]
    private let timer = Timer.publish(every: 2.5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack { // background color; goes first on the "stack"
            LinearGradient(
                gradient: Gradient(colors: [.pink.opacity(0.3), .blue.opacity(0.35)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                //Spacer()
                Text("Welcome to FoodSwipe!")
                    .font(.system(size: 25))
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Image(systemName: "bolt.heart.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.red)
                    .scaleEffect(animate ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 1).repeatForever(), value: animate)
                    .onAppear {
                        animate = true
                    }
                Button(action: {
                    selectedTab = "swipe"
                }) {
                    Text("Start Swiping")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .padding(.horizontal, 40)
                }
                
                
                //Spacer()
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.top, 140)
            
            VStack {
                Spacer()
                Image(mealImages[currentImage])
                    .resizable()
                    .scaledToFit()
                    .frame(height: 210)
                    .cornerRadius(15)
                    .padding(.bottom, 50)
                    .opacity(fadeIn ? 1 : 0)
                    .animation(.easeInOut(duration: 1),  value: fadeIn)
                    .onReceive(timer) { _ in
                        fadeIn = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            currentImage = (currentImage + 1) % mealImages.count
                            fadeIn = true
                        }
                    }
                    .onAppear {
                        fadeIn = true
                    }
                
            }
            
            
            
        }
    }
}
