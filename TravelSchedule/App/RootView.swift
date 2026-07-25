import SwiftUI

/// Заставка держится на экране две секунды, затем сменяется вкладками
struct RootView: View {
    @State private var isSplashVisible = true

    var body: some View {
        ZStack {
            MainTabView()

            if isSplashVisible {
                SplashView()
                    .transition(.opacity)
            }
        }
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
