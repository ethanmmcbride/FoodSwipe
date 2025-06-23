

import SwiftUI

struct PostsView: View {
    var userFoods: [Food]
    @State private var showFilterSheet = false // When the user selects the Filter button, this variable will change to 'true'.
    @State private var selectedFilters: Set<String> = [] // this variable is for the filtration system on the Swipe tab.
    
    var filteredFoods: [Food] {
        userFoods.filter { food in
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
                if userFoods.isEmpty {
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
                    // loops through each meal and finds if the meal matches the user's selected tags
                    ForEach(filteredFoods, id: \.id) { food in
                        VStack(alignment: .leading, spacing: 16) {
                            Image(uiImage: food.image)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 250)
                                .clipped()
                                .cornerRadius(12)
                            
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
                                Text("Total recipes loaded: \(userFoods.count)")
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
            }.scrollContentBackground(.hidden)
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
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button(role: .destructive) {
//                        foodViewModel.clearAllFoods()
//                    } label: {
//                        Text("Clear ALL RECIPES!")
//                    }
//                }
                
            }
            .sheet(isPresented: $showFilterSheet) {
                FilterSheetView(selectedFilters: $selectedFilters)
            } // refreshes data
//            .refreshable {
//                // Force reload data
//                foodViewModel.objectWillChange.send()
//            }
        }
    }
}

struct FilterSheetView: View {
    @Binding var selectedFilters: Set<String>
    @Environment(\.dismiss) var dismiss
    let availableTags = ["Organic", "Low-Calorie", "Gluten-Free"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Filter Recipes")) {
                    ForEach(availableTags, id: \.self) { tag in
                        Toggle(tag, isOn: Binding(
                            get: { selectedFilters.contains(tag)},
                            // will add the tag to the filter if the user toggles it on.
                            set: {isOn in
                                if isOn {
                                    selectedFilters.insert(tag)
                                } else { // if toggled off, remove the tag.
                                    selectedFilters.remove(tag)
                                }
                            }
                        ))
                    }
                }
            }
            .navigationTitle("Filters")
            // Done button lets the user exit out of the filter.
            .navigationBarItems(trailing: Button("Done") {
                // dismisses the sheet.
                dismiss()
            })
            
        }
    }
}

