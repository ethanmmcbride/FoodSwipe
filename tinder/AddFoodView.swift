import SwiftUI

struct AddFoodView: View {
    @State private var title = ""
    @State private var ingredients = ""
    @State private var instructions = ""
    @State private var calories = ""
    @State private var prepTime = ""
    @State private var selectedCategory = "Dinner"
    @State private var tags = ""
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @ObservedObject var viewModel: FoodViewModel
    
    let categories = ["Breakfast", "Lunch", "Dinner", "Snack", "Dessert"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Image
                    ZStack {
                        if let uiImage = selectedImage {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                        } else {
                            Color.gray.opacity(0.2)
                            Image(systemName: "photo")
                                .font(.largeTitle)
                                .foregroundColor(.gray)
                        }
                    }
                    .frame(height: 200)
                    .clipped()
                    .cornerRadius(12)
                    .onTapGesture {
                        showImagePicker = true
                    }

                    // Form Fields
                    Group {
                        TextField("Recipe Title", text: $title)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Ingredients")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            TextEditor(text: $ingredients)
                                .frame(height: 80)
                                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
                        }
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Instructions")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            TextEditor(text: $instructions)
                                .frame(height: 100)
                                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
                        }
                        
                        TextField("Calories", text: $calories)
                            .keyboardType(.numberPad)
                        TextField("Prep Time (e.g., 30 minutes)", text: $prepTime)
                        
                        Picker("Category", selection: $selectedCategory) {
                            ForEach(categories, id: \.self) { category in
                                Text(category)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        
                        TextField("Tags (comma separated)", text: $tags)
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding()
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $selectedImage)
            }
            .alert("Recipe", isPresented: $showAlert) {
                Button("OK") { }
            } message: {
                Text(alertMessage)
            }
            .navigationTitle("New Recipe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Post") {
                        postRecipe()
                    }
                    .disabled(title.isEmpty || selectedImage == nil)
                }
            }
        }
    }
    
    private func postRecipe() {
        guard !title.isEmpty, let image = selectedImage else {
            alertMessage = "Please provide a title and image for your recipe."
            showAlert = true
            return
        }
        
        viewModel.addFood(
            title: title,
            image: image,
            instructions: instructions,
            ingredients: ingredients,
            calories: calories,
            prepTime: prepTime,
            category: selectedCategory,
            tags: tags
        )
        
        // Clear form after successful post
        clearForm()
        
        alertMessage = "Recipe posted successfully!"
        showAlert = true
    }
    
    private func clearForm() {
        title = ""
        ingredients = ""
        instructions = ""
        calories = ""
        prepTime = ""
        selectedCategory = "Dinner"
        tags = ""
        selectedImage = nil
    }
}
