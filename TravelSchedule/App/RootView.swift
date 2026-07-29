import SwiftUI

/// Заставка держится на экране две секунды, затем сменяется вкладками.
/// Здесь же приложению задаётся тема из настроек — системную она не слушает.
struct RootView: View {
    @StateObject private var viewModel = RootViewModel()
    @ObservedObject private var settings = AppSettings.shared

    var body: some View {
        ZStack {
            MainTabView()

            if viewModel.isSplashVisible {
                SplashView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: viewModel.isSplashVisible)
        .preferredColorScheme(settings.colorScheme)
        .task {
            await viewModel.showSplash()
        }
    }
}

#Preview {
    RootView()
}
