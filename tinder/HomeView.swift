import SwiftUI

struct HomeView: View {
    @Binding var selectedTab: Tab
    @ObservedObject var viewModel: FoodViewModel
    @State private var searchText = ""
    @State private var selectedCategory = "All"
    
    private let categories = ["All", "Breakfast", "Lunch", "Dinner", "Snack"]
    
    private let columns = [
        GridItem(.flexible(minimum: 40), spacing: 0),
        GridItem(.flexible(minimum: 40), spacing: 0)
    ]
    
    var filteredRecipes: [Food] {
        var recipes = viewModel.dummyFoods
        
        if selectedCategory != "All" {
            recipes = recipes.filter { $0.category == selectedCategory }
        }
        
        if !searchText.isEmpty {
            recipes = recipes.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.ingredients.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return recipes
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    HeaderView(selectedTab: $selectedTab)
                    
                    
                    // Category Filter
                    CategoryScrollView(
                        categories: categories,
                        selectedCategory: $selectedCategory
                    )
                    
                    
                    VStack {
                        ForEach(filteredRecipes) { recipe in
                            RecipePinView(
                                recipe: recipe,
                                viewModel: viewModel,
                                onTap: {
                                    // Navigate to recipe detail or add to swipe queue
                                    selectedTab = .swipe
                                }
                            )
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .background(Color(.systemBackground))
            .navigationBarHidden(true)
        }
    }
}


struct HeaderView: View {
    @Binding var selectedTab: Tab
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    
                    Text("Home")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                
                Spacer()
                
                Button(action: {
                    selectedTab = .swipe
                }) {
                    HStack {
                        Image(systemName: "bolt.heart.fill")
                            .foregroundColor(.white)
                        Text("Swipe")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [.blue,.blue]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(25)
                }
            }
            .padding(.horizontal)
        }
    }
}


struct CategoryScrollView: View {
    let categories: [String]
    @Binding var selectedCategory: String
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(categories, id: \.self) { category in
                    Button(action: {
                        withAnimation(.spring()) {
                            selectedCategory = category
                        }
                    }) {
                        Text(category)
                            .font(.system(size: 16, weight: .medium))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(
                                selectedCategory == category ?
                                Color.blue : Color(.systemGray6)
                            )
                            .foregroundColor(
                                selectedCategory == category ?
                                .white : .primary
                            )
                            .cornerRadius(20)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}


struct RecipePinView: View {
    let recipe: Food
    @ObservedObject var viewModel: FoodViewModel
    let onTap: () -> Void
    
    @State private var imageHeight: CGFloat = 200
    
    var isLiked: Bool {
        viewModel.isFavorited(recipe)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Recipe Image
            Button(action: onTap) {
                Image(uiImage: recipe.image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 250)
                    .clipped()
                    .cornerRadius(12)
            }
            
            // Recipe Info
            VStack(alignment: .leading, spacing: 8) {
                Text(recipe.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                // Stats Row
                HStack {
                    if !recipe.prepTime.isEmpty {
                        HStack(spacing: 4) {
                            Image(systemName: "clock")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(recipe.prepTime)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        if !recipe.calories.isEmpty {
                            Label(recipe.calories + " cal", systemImage: "flame")
                                .font(.caption)
                                .foregroundColor(.orange)
                        }
                    }
                    
                    Spacer()
                    
                    // Like Button
                    Button(action: {
                        if isLiked {
                            viewModel.removeFavorite(recipe)
                        } else {
                            viewModel.addToFavorites(recipe)
                        }
                    }) {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(isLiked ? .red : .secondary)
                    }
                }
                
                // Category Tag
                Text(recipe.category)
                    .font(.caption)
                    .fontWeight(.medium)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
                    .foregroundColor(.blue)
                    .cornerRadius(8)
            }
            .padding(12)
        }
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        .onAppear {
        }
    }
}


extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
