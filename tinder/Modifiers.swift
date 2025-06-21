import SwiftUI

struct GradientBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.pink.opacity(0.33), Color.blue.opacity(0.3)]),
                    startPoint: .top,
                    endPoint: .bottom
                ).ignoresSafeArea()
            )
    }
}

extension View {
    func applyGradientBackground() -> some View {
        self.modifier(GradientBackground())
    }
}

struct CustomTextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(10)
            .frame(height: 35)
            .background(Color.pink.opacity(0.10))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.pink.opacity(0.3), lineWidth: 1)
            )
    }
}


extension View {
    func customTextField() -> some View {
        self.modifier(CustomTextFieldModifier())
    }
}



