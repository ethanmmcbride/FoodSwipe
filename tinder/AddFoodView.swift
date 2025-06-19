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
                        TextEditor(text: $ingredients)
                            .frame(height: 80)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
                            .padding(.top, -10)
                            
                        
                        TextEditor(text: $instructions)
                            .frame(height: 100)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
                            .padding(.top, -10)
                            
                        
                        TextField("Calories", text: $calories)
                            .keyboardType(.numberPad)
                        TextField("Prep Time", text: $prepTime)
                        
                        Picker("Category", selection: $selectedCategory) {
                            ForEach(categories, id: \.self) { category in
                                Text(category)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        
                        TextField("Tags", text: $tags)
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    // Post Button
                    
                    //.padding(.top, 10)
                }
                .padding()
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $selectedImage)
            }

            .navigationTitle("New Recipe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Post") {
                        if let image = selectedImage {
                            viewModel.addFood(
                                title: title,
                                image: image,
                                instructions: instructions
                            )
                        }
                    }
                }
            }
//            .toolbar {
//                ToolbarItem(placement: .cancellationAction) {
//                    Button("Cancel") {
//                        // Dismiss action
//                    }
//                }
//            }
        }
    }
}

