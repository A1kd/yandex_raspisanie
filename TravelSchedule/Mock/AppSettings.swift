import Combine
import Foundation

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

/// Общие настройки приложения
final class AppSettings: ObservableObject {
    static let shared = AppSettings()

    @Published var errorSimulation: ErrorSimulation = .none

    private init() {}
}
