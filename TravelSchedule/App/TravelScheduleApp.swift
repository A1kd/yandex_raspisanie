import SwiftUI

@main
struct TravelScheduleApp: App {
    init() {
        Self.configureNavigationBar()
    }

    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }

    /// В макете под навигационной панелью нет разделителя,
    /// а заголовок набран тем же чёрным, что и остальной текст
    private static func configureNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color.ypWhite)
        appearance.shadowColor = .clear
        appearance.titleTextAttributes = [.foregroundColor: UIColor(Color.ypBlack)]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }
}
