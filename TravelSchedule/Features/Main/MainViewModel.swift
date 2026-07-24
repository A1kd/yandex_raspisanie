import Combine
import Foundation

/// Какое из двух полей направления сейчас заполняется
enum DirectionField: String, Identifiable {
    case from
    case to

    var id: String { rawValue }

    var placeholder: String {
        switch self {
        case .from: return "Откуда"
        case .to: return "Куда"
        }
    }
}

/// Состояние главного экрана: выбранные точки отправления и назначения
@MainActor
final class MainViewModel: ObservableObject {
    @Published var from: RoutePoint?
    @Published var to: RoutePoint?

    init(from: RoutePoint? = nil, to: RoutePoint? = nil) {
        self.from = from
        self.to = to
    }

    /// Кнопка «Найти» показывается, только когда заполнены оба поля
    var canSearch: Bool {
        from != nil && to != nil
    }

    func point(for field: DirectionField) -> RoutePoint? {
        switch field {
        case .from: return from
        case .to: return to
        }
    }

    func select(_ point: RoutePoint, for field: DirectionField) {
        switch field {
        case .from: from = point
        case .to: to = point
        }
    }

    func swapDirections() {
        (from, to) = (to, from)
    }
}
