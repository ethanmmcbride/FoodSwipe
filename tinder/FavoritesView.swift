import SwiftUI

struct FavoritesView : View {
    var body : some View {
        ZStack{
            VStack {
                Text("❤️ Favorites")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .applyGradientBackground()
        .ignoresSafeArea()
    }
    
}
