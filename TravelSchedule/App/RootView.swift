import SwiftUI

/// Заставка держится на экране две секунды, затем сменяется вкладками.
/// Здесь же приложению задаётся тема из настроек — системную она не слушает.
struct RootView: View {
    @ObservedObject private var settings = AppSettings.shared
    @State private var isSplashVisible = true

    var body: some View {
        ZStack {
            MainTabView()

            if isSplashVisible {
                SplashView()
                    .transition(.opacity)
            }
        }
        .preferredColorScheme(settings.colorScheme)
        .task {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            withAnimation(.easeInOut(duration: 0.3)) {
                isSplashVisible = false
            }
        }
    }
}

#Preview {
    RootView()
}
