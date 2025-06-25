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
    @State private var selectedTags: Set<String> = []
    @ObservedObject var viewModel: FoodViewModel
    
    let categories = ["Breakfast", "Lunch", "Dinner", "Snack", "Dessert"]
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    // Hero Image Section
                    VStack(spacing: 12) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(.systemGray6))
                                .frame(height: 200)
                            
                            if let uiImage = selectedImage {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 200)
                                    .clipped()
                                    .cornerRadius(16)
                            } else {
                                VStack(spacing: 8) {
                                    Image(systemName: "camera.fill")
                                        .font(.system(size: 32, weight: .medium))
                                        .foregroundColor(.secondary)
                                    Text("Add Photo")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .onTapGesture {
                            showImagePicker = true
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .strokeBorder(Color(.systemGray4), lineWidth: 1)
                        )
                    }
                    
                    // Form Section
                    VStack(spacing: 24) {
                        // Basic Info Group
                        VStack(spacing: 16) {
                            FormField(title: "Recipe Name", text: $title, placeholder: "Enter recipe name")
                            
                            FormTextEditor(title: "Ingredients", text: $ingredients, placeholder: "List your ingredients...")
                            
                            FormTextEditor(title: "Instructions", text: $instructions, placeholder: "Describe how to make it...")
                        }
                        
                        // Details Group
                        VStack(spacing: 16) {
                            HStack(spacing: 12) {
                                FormField(title: "Calories", text: $calories, placeholder: "0", keyboardType: .numberPad)
                                FormField(title: "Prep Time", text: $prepTime, placeholder: "30 minutes")
                            }
                            
                            // Category Picker
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Category")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.primary)
                                
                                Menu {
                                    ForEach(categories, id: \.self) { category in
                                        Button(action: {
                                            selectedCategory = category
                                        }) {
                                            HStack {
                                                Text(category)
                                                if selectedCategory == category {
                                                    Spacer()
                                                    Image(systemName: "checkmark")
                                                        .foregroundColor(.accentColor)
                                                }
                                            }
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Text(selectedCategory)
                                            .foregroundColor(.primary)
                                        Spacer()
                                        Image(systemName: "chevron.up.chevron.down")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(12)
                                }
                            }
                        }
                        
                        // Tags Section
                        TagSelectionView(selectedTags: $selectedTags)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .padding(.bottom, 100)
            }
            .background(Color(.systemBackground))
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $selectedImage)
            }
            .alert("Recipe", isPresented: $showAlert) {
                Button("OK") { }
            } message: {
                Text(alertMessage)
            }
            .navigationTitle("New Recipe")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        postRecipe()
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
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
            tags: selectedTags.joined(separator: ",")
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

// MARK: - Form Components
struct FormField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary)
            
            TextField(placeholder, text: $text)
                .keyboardType(keyboardType)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .font(.body)
        }
    }
}

struct FormTextEditor: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary)
            
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
                    .frame(minHeight: 100)
                
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(.secondary)
                        .font(.body)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                }
                
                TextEditor(text: $text)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .font(.body)
            }
        }
    }
}

struct TagSelectionView: View {
    @Binding var selectedTags: Set<String>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Tags")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(FoodViewModel.predefinedTags.prefix(3), id: \.self) { tag in
                    Button(action: {
                        if selectedTags.contains(tag) {
                            selectedTags.remove(tag)
                        } else {
                            selectedTags.insert(tag)
                        }
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: selectedTags.contains(tag) ? "checkmark.circle.fill" : "circle")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(selectedTags.contains(tag) ? .accentColor : .secondary)
                            
                            Text(tag)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.primary)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(selectedTags.contains(tag) ? Color.accentColor.opacity(0.1) : Color(.systemGray6))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(
                                    selectedTags.contains(tag) ? Color.accentColor.opacity(0.3) : Color.clear,
                                    lineWidth: 1
                                )
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
}
