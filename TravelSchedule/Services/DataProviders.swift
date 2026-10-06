import Foundation

/// Источник городов и станций
protocol CityProviding: Sendable {
    func loadCities() async throws -> [City]
}

/// Источник рейсов между двумя точками маршрута
protocol RouteProviding: Sendable {
    func loadSegments(from: RoutePoint, to: RoutePoint) async throws -> [RouteSegment]
}

/// Города и вокзалы из stations_list API «Яндекс Расписаний»
struct NetworkCityProvider: CityProviding {
    private let network: NetworkClient

    init(network: NetworkClient = .shared) {
        self.network = network
    }

    func loadCities() async throws -> [City] {
        // Проверка сети идёт параллельно с запросом: если он упадёт,
        // результат проверки подскажет, какой экран ошибки показать
        async let isOnline = NetworkReachability.isOnline()
        do {
            return try await network.cities()
        } catch {
            try Task.checkCancellation()
            throw (await isOnline) ? AppError.serverError : AppError.noInternet
        }
    }
}

/// Рейсы из /search/ API «Яндекс Расписаний»
struct NetworkRouteProvider: RouteProviding {
    /// В макете список рейсов охватывает несколько дней,
    /// а API отвечает на конкретную дату — запрашиваем ближайшие дни
    private static let daysToLoad = 3

    private let network: NetworkClient

    init(network: NetworkClient = .shared) {
        self.network = network
    }

    func loadSegments(from: RoutePoint, to: RoutePoint) async throws -> [RouteSegment] {
        async let isOnline = NetworkReachability.isOnline()
        do {
            // Дни независимы друг от друга — их можно грузить одновременно
            let segments = try await withThrowingTaskGroup(of: [RouteSegment].self) { group in
                for date in Self.upcomingDates() {
                    group.addTask {
                        let response = try await network.searchRoutes(
                            from: from.station.id,
                            to: to.station.id,
                            date: date,
                            transfers: true
                        )
                        return SegmentsMapper.segments(from: response)
                    }
                }
                return try await group.reduce(into: [RouteSegment]()) { $0 += $1 }
            }
            return segments.sorted { $0.departure < $1.departure }
        } catch {
            try Task.checkCancellation()
            throw (await isOnline) ? AppError.serverError : AppError.noInternet
        }
    }

    /// Сегодня и ближайшие дни в формате YYYY-MM-DD
    private static func upcomingDates() -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let calendar = Calendar.current
        return (0..<daysToLoad).compactMap { offset in
            calendar.date(byAdding: .day, value: offset, to: Date()).map(formatter.string(from:))
        }
    }
}
