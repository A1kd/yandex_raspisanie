import SwiftUI

/// Две вкладки: слева расписание, справа настройки
struct MainTabView: View {
    var body: some View {
        TabView {
            NavigationStack {
                MainView()
            }
            .tabItem {
                Image("icSchedule")
                    .renderingMode(.template)
            }

            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Image("icSettings")
                    .renderingMode(.template)
            }
        }
        .tint(Color.ypBlack)
    }
}

#Preview {
    MainTabView()
}
