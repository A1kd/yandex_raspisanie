import Foundation

/// Рейс между двумя точками маршрута — одна карточка в списке
struct RouteSegment: Identifiable, Hashable {
    let id: String
    let carrier: Carrier
    let departure: Date
    let arrival: Date
    /// Город пересадки, если рейс с пересадкой
    let transferPlace: String?

    var hasTransfer: Bool {
        transferPlace != nil
    }

    /// «С пересадкой в Костроме» — красная подпись под названием перевозчика
    var transferText: String? {
        transferPlace.map { "С пересадкой в \($0)" }
    }

    /// «14 января» — дата отправления в правом верхнем углу карточки
    var dateText: String {
        RouteSegment.dateFormatter.string(from: departure)
    }

    /// «22:30»
    var departureText: String {
        RouteSegment.timeFormatter.string(from: departure)
    }

    /// «08:15»
    var arrivalText: String {
        RouteSegment.timeFormatter.string(from: arrival)
    }

    /// «20 часов» — время в пути между временами отправления и прибытия
    var durationText: String {
        let hours = max(1, Int((arrival.timeIntervalSince(departure) / 3600).rounded()))
        return "\(hours) \(RouteSegment.hoursWord(for: hours))"
    }

    /// Час отправления — по нему рейс попадает в интервал фильтра
    var departureHour: Int {
        Calendar.current.component(.hour, from: departure)
    }

    private static func hoursWord(for hours: Int) -> String {
        let remainder100 = hours % 100
        let remainder10 = hours % 10
        if (11...14).contains(remainder100) { return "часов" }
        switch remainder10 {
        case 1: return "час"
        case 2...4: return "часа"
        default: return "часов"
        }
    }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMMM"
        return formatter
    }()

    private static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
}
