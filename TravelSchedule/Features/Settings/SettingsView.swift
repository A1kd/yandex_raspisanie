import SwiftUI

/// Заглушка экрана настроек — сам экран верстается в следующем спринте.
/// Здесь же переключатель симуляции ошибок: он позволяет посмотреть
/// экраны «Ошибка сервера» и «Нет интернета» на любом экране с загрузкой.
struct SettingsView: View {
    @ObservedObject private var settings = AppSettings.shared

    var body: some View {
        VStack(spacing: 32) {
            Text("Настройки")
                .appFont(.bold24)
                .foregroundStyle(Color.ypBlack)

            VStack(alignment: .leading, spacing: 8) {
                Text("Симуляция ошибки")
                    .appFont(.regular17)
                    .foregroundStyle(Color.ypBlack)

                Picker("Симуляция ошибки", selection: $settings.errorSimulation) {
                    ForEach(ErrorSimulation.allCases) { simulation in
                        Text(simulation.title).tag(simulation)
                    }
                }
                .pickerStyle(.segmented)
            }
            .padding(.horizontal, 16)

            Spacer()
        }
        .padding(.top, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.ypWhite)
    }
}

#Preview {
    SettingsView()
}
