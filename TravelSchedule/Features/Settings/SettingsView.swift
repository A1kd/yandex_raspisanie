import SwiftUI

/// Настройки: переключение темы и переход к пользовательскому соглашению
struct SettingsView: View {
    @ObservedObject private var settings = AppSettings.shared
    @State private var isAgreementShown = false

    var body: some View {
        VStack(spacing: 0) {
            Toggle(isOn: $settings.isDarkTheme) {
                Text("Темная тема")
                    .appFont(.regular17)
                    .foregroundStyle(Color.ypBlack)
            }
            .tint(Color.ypBlue)
            .padding(.horizontal, 16)
            .frame(height: 60)
            .accessibilityIdentifier("theme-toggle")

            Button {
                isAgreementShown = true
            } label: {
                ListRow(title: "Пользовательское соглашение")
            }
            .accessibilityIdentifier("agreement-row")

            Spacer()

            VStack(spacing: 16) {
                Text("Приложение использует API «Яндекс.Расписания»")
                Text("Версия 1.0 (beta)")
            }
            .appFont(.regular12)
            .foregroundStyle(Color.ypBlack)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .padding(.top, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.ypWhite)
        .fullScreenCover(isPresented: $isAgreementShown) {
            AgreementView()
        }
    }
}

#Preview {
    SettingsView()
}
