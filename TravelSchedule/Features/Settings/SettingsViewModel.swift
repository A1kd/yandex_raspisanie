import Combine
import Foundation

/// Настройки: переключатель тёмной темы и показ пользовательского соглашения
@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var isDarkTheme: Bool {
        didSet { settings.isDarkTheme = isDarkTheme }
    }

    @Published var isAgreementShown = false

    let aboutText = "Приложение использует API «Яндекс.Расписания»"
    let versionText = "Версия 1.0 (beta)"

    private let settings: AppSettings

    init(settings: AppSettings = .shared) {
        self.settings = settings
        isDarkTheme = settings.isDarkTheme
    }

    func showAgreement() {
        isAgreementShown = true
    }
}
