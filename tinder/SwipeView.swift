import SwiftUI

struct SwipeView: View {
    @StateObject private var foodViewModel = FoodViewModel()
    @State private var showFilterSheet = false // When the user selects the Filter button, this variable will change to 'true'.
    @State private var selectedFilters: Set<String> = [] // this variable is for the filtration system on the Swipe tab.
    @State private var currIndex = 0;
    
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
                    Text("No recipes found. Try changing your filters.")
                        .foregroundStyle(.secondary)
                } else if currIndex < filteredFoods.count {
                    RecipeCardView(
                        food: filteredFoods[currIndex],
                        totalRecipes: foodViewModel.dummyFoods.count,
                        onSwipe: {
                            if currIndex < filteredFoods.count {
                                currIndex += 1
                            }
                        }
                    )
                } else {
                    VStack {
                        Spacer()
                        Text("No more recipes to show!")
                            .multilineTextAlignment(.center)
                            .font(.headline)
                        Spacer()
                    }
                    .offset(y: 250)
                }
            }
            .scrollContentBackground(.hidden)
            .navigationTitle("Swipe")
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
    let onSwipe: () -> Void
    @State private var isLiked = false
    @State private var isDisliked = false
    @State private var shake: CGFloat = 0
    @StateObject private var foodViewModel = FoodViewModel()
    //
    
    // Function To Trigger the "Shake":
    func triggerShake(completion: @escaping ()  -> Void) {
        withAnimation(.default) {
            shake = 10
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.default) {
                shake = -10
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.default) {
                shake = 0
            }
            completion() // will switch to the next recipe after the button is finished shaking.
        }
    }
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
                    // if the dislike button is clicked, then the isLiked var is assigned a false value.
                    if isDisliked { isLiked = false }
                    // TRIGGERED SHAKE AND SWIPE!
                    triggerShake {
                        // the dispatch call will give the button some time to shake properly.
                        DispatchQueue.main.asyncAfter(deadline: .now() +  0.3) {
                            onSwipe()
                        }
                        
                    }
                }) {
                    Label("Dislike", systemImage: isDisliked ? "hand.thumbsdown.fill" : "hand.thumbsdown")
                        .foregroundColor(isDisliked ? .red : .gray)
                }
                Spacer()
                Button(action: {
                    print("Liked: \(food.title)")
                    isLiked.toggle()
                    // if the like button is clicked, then the isDisliked var is assigned a false value.
                    if isLiked { isDisliked = false
                        foodViewModel.addToFavorites(food)}
                    // TRIGGERED SHAKE AND SWIPE!
                    triggerShake {
                        DispatchQueue.main.asyncAfter(deadline: .now() +  0.3) {
                            onSwipe()
                        }
                    }
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
        .offset(x: shake)
        .onChange(of: food.id) { _, _ in
            isLiked = false
            isDisliked = false
        }
    }
    
}

    
    
    

