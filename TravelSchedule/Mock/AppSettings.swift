import Combine
import Foundation
import SwiftUI

/// Что должны вернуть провайдеры данных вместо ответа.
/// Переключается на экране настроек, чтобы можно было посмотреть
/// экраны ошибок без отключения сети.
enum ErrorSimulation: String, CaseIterable, Identifiable {
    case none
    case server
    case noInternet

    var id: String { rawValue }

    var title: String {
        switch self {
        case .none: return "Нет"
        case .server: return "Ошибка сервера"
        case .noInternet: return "Нет интернета"
        }
    }

    var error: AppError? {
        switch self {
        case .none: return nil
        case .server: return .serverError
        case .noInternet: return .noInternet
        }
    }
}

/// Общие настройки приложения. Тема и просмотренные истории
/// переживают перезапуск — они хранятся в UserDefaults.
/// Настройки читаются только интерфейсом, поэтому класс привязан к главному актору.
@MainActor
final class AppSettings: ObservableObject {
    static let shared = AppSettings()

    /// Тема приложения задаётся переключателем в настройках и не зависит от системной
    @Published var isDarkTheme: Bool {
        didSet { defaults.set(isDarkTheme, forKey: Keys.isDarkTheme) }
    }

    /// Истории, которые пользователь уже открывал — они показываются приглушёнными
    @Published private(set) var seenStoryIDs: Set<Int> {
        didSet { defaults.set(Array(seenStoryIDs), forKey: Keys.seenStoryIDs) }
    }

    var colorScheme: ColorScheme {
        isDarkTheme ? .dark : .light
    }

    private let defaults: UserDefaults

    private enum Keys {
        static let isDarkTheme = "isDarkTheme"
        static let seenStoryIDs = "seenStoryIDs"
    }

    private init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        isDarkTheme = defaults.bool(forKey: Keys.isDarkTheme)
        seenStoryIDs = Set(defaults.array(forKey: Keys.seenStoryIDs) as? [Int] ?? [])
    }

    func markStorySeen(_ id: Int) {
        seenStoryIDs.insert(id)
    }
}
