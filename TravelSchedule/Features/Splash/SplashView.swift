import SwiftUI

/// Экран заставки: иллюстрация из макета на весь экран, включая безопасные зоны
struct SplashView: View {
    var body: some View {
        Image("splashScreen")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
            .background(Color.black.ignoresSafeArea())
    }
}

#Preview {
    SplashView()
}
