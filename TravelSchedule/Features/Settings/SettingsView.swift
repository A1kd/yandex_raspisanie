import SwiftUI

/// Настройки: переключение темы и переход к пользовательскому соглашению
struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()

    var body: some View {
        VStack(spacing: 0) {
            Toggle(isOn: $viewModel.isDarkTheme) {
                Text("Темная тема")
                    .appFont(.regular17)
                    .foregroundStyle(Color.ypBlack)
            }
            .tint(Color.ypBlue)
            .padding(.horizontal, 16)
            .frame(height: 60)
            .accessibilityIdentifier("theme-toggle")

            Button {
                viewModel.showAgreement()
            } label: {
                ListRow(title: "Пользовательское соглашение")
            }
            .accessibilityIdentifier("agreement-row")

            Spacer()

            VStack(spacing: 16) {
                Text(viewModel.aboutText)
                Text(viewModel.versionText)
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
        .fullScreenCover(isPresented: $viewModel.isAgreementShown) {
            AgreementView()
        }
    }
}

#Preview {
    SettingsView()
}
