import SwiftUI
import UIKit
import Foundation


struct Food: Identifiable, Codable {
    var id = UUID()
    var title: String
    var imageData: Data
    var instructions: String
    var ingredients: String
    var calories: String
    var prepTime: String
    var category: String
    var tags: String
    var dateCreated: Date

    
    
    // This is here because UIImage isn't compatible with json
    var image: UIImage {
        return UIImage(data: imageData) ?? UIImage(systemName: "photo")!
    }
    
    // Initialize with UIImage --> converts to type Data
    init(title: String, image: UIImage, instructions: String, ingredients: String = "", calories: String = "", prepTime: String = "", category: String = "Dinner", tags: String = "") {
        self.title = title
        self.imageData = image.jpegData(compressionQuality: 0.8) ?? Data()
        self.instructions = instructions
        self.ingredients = ingredients
        self.calories = calories
        self.prepTime = prepTime
        self.category = category
        self.tags = tags
        self.dateCreated = Date()
    }
}

class FoodViewModel: ObservableObject {
    @Published var dummyFoods: [Food] = []
    @Published var userFoods: [Food] = []
    static let predefinedTags: [String] = [
        "Organic", "Low-Calorie", "Gluten-Free"
    ]

    
    // File URL for storing JSON data
    private var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    private var foodsFileURL: URL {
        documentsDirectory.appendingPathComponent("foods.json")
    }
    
    init() {
        loadDummyFoods()
    }
    
    func loadDummyFoods() {
        dummyFoods = dummyFoodsData

        loadFoods()
        if dummyFoods.isEmpty {
            dummyFoods = DummyData.foods
            saveFoods()
        }
    }
    
    // Add food with all parameters
    func addFood(title: String, image: UIImage, instructions: String, ingredients: String = "", calories: String = "", prepTime: String = "", category: String = "Dinner", tags: String = "") {
        let newFood = Food(
            title: title,
            image: image,
            instructions: instructions,
            ingredients: ingredients,
            calories: calories,
            prepTime: prepTime,
            category: category,
            tags: tags
        )
        userFoods.append(newFood)
        saveFoods()
    }
    
    // Save foods to JSON file
    private func saveFoods() {
        do {
            let data = try JSONEncoder().encode(userFoods)
            try data.write(to: foodsFileURL)
            print("Foods saved successfully to: \(foodsFileURL.path)")
        } catch {
            print("Failed to save foods: \(error.localizedDescription)")
        }
    }
    
    // Load foods from JSON file
    private func loadFoods() {
        do {
            let data = try Data(contentsOf: foodsFileURL)
            userFoods = try JSONDecoder().decode([Food].self, from: data)
            print("Foods loaded successfully from: \(foodsFileURL.path)")
        } catch {
            print("Failed to load foods: \(error.localizedDescription)")
            // If file doesn't exist or can't be loaded, start with empty array
            userFoods = []
        }
    }
    
    // Delete a food item
    func deleteFood(at indexSet: IndexSet) {
        userFoods.remove(atOffsets: indexSet)
        saveFoods()
    }
    
    // Delete a specific food item
    func deleteFood(_ food: Food) {
        userFoods.removeAll { $0.id == food.id }
        saveFoods()
    }
//    func clearAllFoods() {
//        userFoods.removeAll()
//        saveFoods()
//    }
}

