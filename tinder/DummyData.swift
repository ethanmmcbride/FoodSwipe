import Foundation
import SwiftUI


struct DummyData {
    
    
    static let foods: [Food] = [
        Food(
            title: "Spaghetti Carbonara",
            image: UIImage(named: "MealNumberOne") ?? UIImage(systemName: "photo")!,
            instructions: "1. Boil pasta.\n2. Fry Bacon.\n3. Mix with eggs, cheese, and black pepper.\n4. Combine all ingredients and serve hot.",
            ingredients: "Spaghetti, Eggs, Bacon, Cheese, Black pepper.",
            calories: "550",
            prepTime: "30 minutes",
            category: "Dinner",
            tags: "Organic"
        ),
        Food(
            title: "Breakfast Burrito",
            image: UIImage(named: "MealNumberTwo") ?? UIImage(systemName: "photo")!,
            instructions: "1. Scramble eggs.\n2. Fry bacon.\n3. Warm tortilla.\n4. Assemble burrito with eggs, bacon, cheese, and salsa.",
            ingredients: "2 large eggs, 2 tablespoons salsa, 1 slice of bacon, 1 slice of cheese, 1 flour tortilla.",
            calories: "460",
            prepTime: "15 minutes",
            category: "Breakfast",
            tags: "Low-Calorie"
        ),
        Food(
            title: "Spinach and Artichoke Ranch Dip",
            image: UIImage(named: "MealNumberThree") ?? UIImage(systemName: "photo")!,
            instructions: "1. Blend spinach, artichoke hearts, sour cream, ranch dressing, and Parmesan cheese.\n2. Serve with tortilla chips or crackers.",
            ingredients: "Spinach, Artichoke hearts, Sour cream, Ranch dressing, Parmesan cheese.",
            calories: "320",
            prepTime: "10 minutes",
            category: "Snack",
            tags: "Vegetarian"
        )
    ]
}
