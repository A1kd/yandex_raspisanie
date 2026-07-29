import Combine
import Foundation

/// Управляет заставкой: она держится на экране две секунды,
/// затем сменяется вкладками приложения
@MainActor
final class RootViewModel: ObservableObject {
    /// Сколько показывается заставка
    private static let splashDuration: Duration = .seconds(2)

    @Published private(set) var isSplashVisible = true

    func showSplash() async {
        try? await Task.sleep(for: Self.splashDuration)
        isSplashVisible = false
    }
}
