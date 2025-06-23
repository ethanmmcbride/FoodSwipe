import Foundation
import SwiftUI

<<<<<<< HEAD
let dummyFoodsData: [Food] = [
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
        ingredients: "Spinach, Artichoke hearts, sour cream, ranch, and parmesan cheese (store brand is fine).",
        calories: "320",
        prepTime: "10 minutes",
        category: "Snack",
        tags: "Organic, Low-Calorie"
    ),
    Food (
        title: "Grilled Chicken Salad",
        image: UIImage(named: "MealNumberFour") ?? UIImage(systemName: "photo")!,
        instructions: "1. Grill chicken breast.\n2. Toss with lettuce, tomatoes, cucumbers, and vinaigrette.\n3. Serve chilled.",
        ingredients: "Grilled chicken breast, lettuce, tomatoes, cucumbers, and vinaigrette dressing.",
        calories: "280",
        prepTime: "20 minutes",
        category: "Lunch",
        tags: "Low-Calorie, Gluten-Free"
    ),
    Food(
        title: "Tofu Stir Fry",
        image: UIImage(named: "MealNumberFive") ?? UIImage(systemName: "photo")!,
        instructions: "1. Cube tofu and fry in sesame oil.\n2. Stir fry with bell peppers and broccoli.\n3. Serve with rice.",
        ingredients: "Tofu, bell peppers, broccoli, and sesame oil.",
        calories: "400",
        prepTime: "25 minutes",
        category: "Dinner",
        tags: "Gluten-Free"
    ),
    Food(
        title: "Zucchini Noodles with Pesto",
        image: UIImage(named: "MealNumberSix") ?? UIImage(systemName: "photo")!,
        instructions: "1. Spiralize zucchini into noodles.\n2. Blend basil, garlic, olive oil, and pine nuts into pesto.\n3. Toss zoodles with pesto and cherry tomatoes.\n4. Serve fresh or lightly sautéed.",
        ingredients: "2 organic zucchinis, organic basil, 1 garlic clove, olive oil, pine nuts, cherry tomatoes.",
        calories: "210",
        prepTime: "15 minutes",
        category: "Dinner",
        tags: "Gluten-Free, Low-Calorie, Organic"
    ),
    Food(
        title: "Creamy Coconut Chickpea Curry",
        image: UIImage(named: "MealNumberSeven") ?? UIImage(systemName: "photo")!,
        instructions: "1. Saute onions, garlic, and ginger.\n2. Add canned tomatoes and simmer on medium heat.\n3. Stir in chickpeas and coconut milk.\n4. Add spices and cook for 15 minutes.\n5. Serve over a bed of rice.",
        ingredients: "Organic chickpeas, coconut milk, organic onion, garlic cloves, 1 tbsp grated ginger, spices (tumeric, cumin, coriander), 1 cup of rice.",
        calories: "650",
        prepTime: "30 minutes",
        category: "Dinner",
        tags: "Gluten-Free, Organic"
    )
]
=======

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
>>>>>>> main
