import SwiftUI

struct SwipeView: View {
    @StateObject private var foodViewModel = FoodViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                if foodViewModel.foods.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "fork.knife.circle")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("No recipes saved yet!")
                            .font(.title2)
                            .foregroundColor(.secondary)
                        Text("Add some recipes in the Add Food tab to see them here.")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                } else {
                    // Display the last entered food item
                    let firstFood = foodViewModel.foods[foodViewModel.foods.count - 1]
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Image(uiImage: firstFood.image)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 250)
                            .clipped()
                            .cornerRadius(12)
                        
                        Text(firstFood.title) // Title
                            .font(.title)
                            .fontWeight(.bold)
                        
                        HStack { // Category and Date
                            Text(firstFood.category)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(8)
                                .font(.caption)
                            
                            Spacer()
                            
                            Text(firstFood.dateCreated, style: .date)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        HStack { // Stats
                            if !firstFood.calories.isEmpty {
                                Label(firstFood.calories + " cal", systemImage: "flame")
                                    .font(.caption)
                                    .foregroundColor(.orange)
                            }
                            
                            if !firstFood.prepTime.isEmpty {
                                Label(firstFood.prepTime, systemImage: "clock")
                                    .font(.caption)
                                    .foregroundColor(.blue)
                            }
                        }
                        
                        if !firstFood.ingredients.isEmpty { // Ingredients
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Ingredients")
                                    .font(.headline)
                                Text(firstFood.ingredients)
                                    .font(.body)
                            }
                        }
                        
                        if !firstFood.instructions.isEmpty { // Instructions
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Instructions")
                                    .font(.headline)
                                Text(firstFood.instructions)
                                    .font(.body)
                            }
                        }
                                                
                        if !firstFood.tags.isEmpty { // Tags
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Tags")
                                    .font(.headline)
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack {
                                        ForEach(firstFood.tags.components(separatedBy: ","), id: \.self) { tag in
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
                            Text("Total recipes loaded: \(foodViewModel.foods.count)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("Recipe ID: \(firstFood.id.uuidString)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.top)
                    }
                    .padding()
                }
            }
            .navigationTitle("Recipe Test")
            .refreshable {
                // Force reload data
                foodViewModel.objectWillChange.send()
            }
        }
    }
}
