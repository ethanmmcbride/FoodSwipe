import SwiftUI

struct SwipeView: View {
    @StateObject private var foodViewModel = FoodViewModel()
    @State private var showFilterSheet = false // When the user selects the Filter button, this variable will change to 'true'.
    @State private var selectedFilters: Set<String> = [] // this variable is for the filtration system on the Swipe tab.
    
    var filteredFoods: [Food] {
        foodViewModel.dummyFoods.filter { food in
            let tagList = food.tags
            // removes extra spaces and splits the tags into an array
                .components(separatedBy: ",")
                .map { $0.trimmingCharacters(in: .whitespaces)}
            // uses an unordered and unique set
            return selectedFilters.isEmpty || Set(tagList) == selectedFilters
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                if filteredFoods.isEmpty {
                    Text("No recipes match your selected filters!")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(filteredFoods, id: \.id) { food in
                        RecipeCardView(food: food, totalRecipes: foodViewModel.dummyFoods.count)
                        
                        
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .navigationTitle("Recipe Test")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // changes filter sheet var to 'true' when button is pressed.
                        showFilterSheet = true
                    }) {
                        Label("Filter", systemImage: "line.horizontal.3.decrease.circle")
                    }
                }
                
            }
            .sheet(isPresented: $showFilterSheet) {
                FilterSheetView(selectedFilters: $selectedFilters)
            } // refreshes data
            .refreshable {
                // Force reload data
                foodViewModel.objectWillChange.send()
            }
        }
    }
}

struct RecipeCardView: View {
    let food: Food
    let totalRecipes: Int
    @State private var isLiked = false
    @State private var isDisliked = false
            
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Image(uiImage: food.image)
                .resizable()
                .scaledToFill()
                .frame(height: 250)
                .clipped()
                .cornerRadius(12)
            
            HStack {
                Button(action: {
                    print("Disliked: \(food.title)")
                    isDisliked.toggle()
                    if isDisliked { isLiked = false }
                }) {
                    Label("Dislike", systemImage: isDisliked ? "hand.thumbsdown.fill" : "hand.thumbsdown")
                        .foregroundColor(isDisliked ? .red : .gray)
                }
                Spacer()
                Button(action: {
                    print("Liked: \(food.title)")
                    isLiked.toggle()
                    if isLiked { isDisliked = false }
                }) {
                    Label("Like", systemImage: isLiked ? "hand.thumbsup.fill" : "hand.thumbsup")
                        .foregroundColor(isLiked ? .blue : .gray)
                    }
            }
            .padding(.horizontal, 100)
            
            Text(food.title) // Title
                .font(.title)
                .fontWeight(.bold)
            
            HStack { // Category and Date
                Text(food.category)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(8)
                    .font(.caption)
                
                Spacer()
                
                Text(food.dateCreated, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            HStack { // Stats
                if !food.calories.isEmpty {
                    Label(food.calories + " cal", systemImage: "flame")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
                
                if !food.prepTime.isEmpty {
                    Label(food.prepTime, systemImage: "clock")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
            
            if !food.ingredients.isEmpty { // Ingredients
                VStack(alignment: .leading, spacing: 8) {
                    Text("Ingredients")
                        .font(.headline)
                    Text(food.ingredients)
                        .font(.body)
                }
            }
            
            if !food.instructions.isEmpty { // Instructions
                VStack(alignment: .leading, spacing: 8) {
                    Text("Instructions")
                        .font(.headline)
                    Text(food.instructions)
                        .font(.body)
                }
            }
            
            if !food.tags.isEmpty { // Tags
                VStack(alignment: .leading, spacing: 8) {
                    Text("Tags")
                        .font(.headline)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(food.tags.components(separatedBy: ","), id: \.self) { tag in
                                Text(tag.trimmingCharacters(in: .whitespaces))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(6)
                                    .font(.caption)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 4) { // Debug info
                Text("Debug Info")
                    .font(.headline)
                    .foregroundColor(.secondary)
                Text("Total recipes loaded: \(totalRecipes)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("Recipe ID: \(food.id.uuidString)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.top)
        }
        .padding()
    }
}

            


