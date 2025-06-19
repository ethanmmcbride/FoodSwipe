import SwiftUI

struct Food: Identifiable {
    let id = UUID()
    var title: String
    var image: UIImage
    var instructions: String
}

class FoodViewModel: ObservableObject {
    @Published var foods: [Food] = []
    
    func addFood(title: String, image: UIImage, instructions: String) {
        let newFood = Food(title: title, image: image, instructions: instructions)
        foods.append(newFood)
    }
}

