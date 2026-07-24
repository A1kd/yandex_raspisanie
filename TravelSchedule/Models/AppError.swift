import Foundation

/// Ошибки, для которых в макете есть отдельные экраны
enum AppError: Error, Equatable {
    case serverError
    case noInternet

    var title: String {
        switch self {
        case .serverError: return "Ошибка сервера"
        case .noInternet: return "Нет интернета"
        }
    }

    /// Имя иллюстрации в Assets
    var imageName: String {
        switch self {
        case .serverError: return "serverError"
        case .noInternet: return "noInternet"
        }
    }
}
