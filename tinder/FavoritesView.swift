import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel: FoodViewModel
    @State private var searchText = ""
    
    var filteredFavorites: [Food] {
        if searchText.isEmpty {
            return viewModel.likedFoods
        } else {
            return viewModel.likedFoods.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.category.localizedCaseInsensitiveContains(searchText) ||
                $0.tags.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Header with search
                VStack(spacing: 15) {
                    HStack {
                        Text("My Favorites")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        Spacer()
                        Text("\(viewModel.likedFoods.count) recipes")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.black.opacity(0.8))
                    }
                    .padding(.horizontal)
                    .padding(.top, 15)
                    
                    // Search bar
                    SearchBar(text: $searchText)
                        .searchable(text: $searchText)
                }
                
                // Content
                if filteredFavorites.isEmpty {
                    EmptyFavoritesView(hasSearchText: !searchText.isEmpty)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredFavorites) { favorite in
                                FavoriteRecipeItemView(food: favorite) {
                                    viewModel.removeFavorite(favorite)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 15)
                        .padding(.bottom, 20)
                    }
                }
                
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct FavoriteRecipeItemView: View {
    let food: Food
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 15) {
            // Recipe image
            Image(uiImage: food.image)
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.black.opacity(0.2), lineWidth: 1)
                )
            
            // Recipe details
            VStack(alignment: .leading, spacing: 4) {
                Text(food.title)
                    .font(.headline)
                    .foregroundColor(.black)
                    .lineLimit(1)
                
                Text(food.category)
                    .font(.subheadline)
                    .foregroundColor(.black.opacity(0.8))
                    .lineLimit(1)
                
                HStack(spacing: 8) {
                    if !food.calories.isEmpty {
                        HStack(spacing: 2) {
                                Label(food.calories + " cal", systemImage: "flame")
                                    .font(.caption)
                                    .foregroundColor(.orange)
                        }
                    }
                    
                    if !food.prepTime.isEmpty {
                        Text("•")
                            .foregroundColor(.white.opacity(0.5))
                        
                        HStack(spacing: 2) {
                            Image(systemName: "clock")
                                .font(.caption)
                                .foregroundColor(.blue)
                            Text(food.prepTime)
                                .font(.caption)
                                .foregroundColor(.black.opacity(0.7))
                        }
                    }
                }
            }
            
            Spacer()
            
            // Remove button
            Button(action: onRemove) {
                Image(systemName: "heart.fill")
                    .font(.title3)
                    .foregroundColor(.red.opacity(0.8))
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.white.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.white.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

struct EmptyFavoritesView: View {
    let hasSearchText: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: hasSearchText ? "magnifyingglass" : "heart.slash")
                .font(.system(size: 60))
                .foregroundColor(.black.opacity(0.6))
            
            VStack(spacing: 8) {
                Text(hasSearchText ? "No results found" : "No favorite recipes yet")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                
                Text(hasSearchText ? "Try searching for something else" : "Start liking recipes in the swipe view!")
                    .font(.body)
                    .foregroundColor(.black.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
            
            if !hasSearchText {
                Button(action: {
                    // Action to navigate to discover foods
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Discover Recipes")
                    }
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(.white.opacity(0.2))
                    )
                }
                .padding(.top, 10)
            }
            
            Spacer()
        }
        .padding(.horizontal)
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.black.opacity(0.6))
            
            TextField("Search recipes...", text: $text)
                .foregroundColor(.black)
                .placeholder(when: text.isEmpty) {
                    Text("Search recipes...")
                        .foregroundColor(.black.opacity(0.5))
                }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.white.opacity(0.15))
        )
    }
}

// Extension for placeholder
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
