import SwiftUI

struct SwipeView : View {
    var body : some View {
        ZStack{
            VStack {
                Text("👋 Swipe")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .applyGradientBackground()
        .ignoresSafeArea()
    }
    
}
