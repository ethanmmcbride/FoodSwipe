import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: FoodViewModel
    @State private var selectedTab: ProfileTab = .posts
    
    enum ProfileTab {
        case posts
        case favorites
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Top quarter - User header with tab selector
            VStack {
                Text("User Profile")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                // Custom tab selector
                HStack(spacing: 0) {
                    Button(action: { selectedTab = .posts }) {
                        Text("My Posts")
                            .frame(maxWidth: .infinity, minHeight: 44)
                            .background(selectedTab == .posts ? Color.blue : Color.clear)
                            .foregroundColor(selectedTab == .posts ? .white : .primary)
                    }
                    
                    Button(action: { selectedTab = .favorites }) {
                        Text("My Favorites")
                            .frame(maxWidth: .infinity, minHeight: 44)
                            .background(selectedTab == .favorites ? Color.blue : Color.clear)
                            .foregroundColor(selectedTab == .favorites ? .white : .primary)
                    }
                }
                .background(Color(.systemGray5))
                .cornerRadius(8)
                .padding(.horizontal)
                .padding(.bottom, 10)
            }
            .frame(height: UIScreen.main.bounds.height * 0.25)
            .background(Color(.systemBackground))
            
            // Bottom 3/4 - Content area
            Group {
                switch selectedTab {
                case .posts:
                    PostsView(userFoods: viewModel.userFoods)
                case .favorites:
                    FavoritesView()
                }
            }
            .frame(maxHeight: .infinity)
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
}
