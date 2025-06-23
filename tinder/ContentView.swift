import SwiftUI

struct ContentView : View {
    @AppStorage("selectedTab") private var selectedTab = "home"
    @StateObject var foodViewModel = FoodViewModel()
    var body : some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home Page", systemImage: "house.fill")
                }.tag("home")
            AddFoodView(viewModel: foodViewModel)
                .tabItem {
                    Label("Add Food", systemImage: "fork.knife.circle.fill")
                }.tag("add")
            
            SwipeView()
                .tabItem {
                    Label("Swipe", systemImage: "hand.draw")
                }.tag("swipe")
            
            ProfileView(viewModel: foodViewModel)
                .tabItem {
                    Label("Profile", systemImage: "person")
                }.tag("profile")
        }
        .tabViewStyle(.sidebarAdaptable)
    }
}


#Preview {
    ContentView()
}
