import Foundation

/// Интервал отправления с экрана «Уточнить время»
enum DepartureInterval: String, CaseIterable, Identifiable {
    case morning
    case afternoon
    case evening
    case night

    var id: String { rawValue }

    var title: String {
        switch self {
        case .morning: return "Утро 06:00 - 12:00"
        case .afternoon: return "День 12:00 - 18:00"
        case .evening: return "Вечер 18:00 - 00:00"
        case .night: return "Ночь 00:00 - 06:00"
        }
    }

    /// Часы отправления, попадающие в интервал
    var hours: Range<Int> {
        switch self {
        case .morning: return 6..<12
        case .afternoon: return 12..<18
        case .evening: return 18..<24
        case .night: return 0..<6
        }
    }

    func contains(hour: Int) -> Bool {
        hours.contains(hour)
    }
}

/// Настройки фильтрации списка рейсов
struct RouteFilter: Equatable {
    var intervals: Set<DepartureInterval> = []
    /// nil — пользователь ещё не выбрал вариант с пересадками
    var showsTransfers: Bool?

    /// Пустой фильтр не влияет на список и не подсвечивает кнопку «Уточнить время»
    var isEmpty: Bool {
        intervals.isEmpty && showsTransfers == nil
    }

    func matches(_ segment: RouteSegment) -> Bool {
        if !intervals.isEmpty {
            let fits = intervals.contains { $0.contains(hour: segment.departureHour) }
            guard fits else { return false }
        }
        if let showsTransfers, !showsTransfers, segment.hasTransfer {
            return false
        }
        return true
    }
}
