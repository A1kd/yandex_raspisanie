import Foundation

/// Источник городов и станций
protocol CityProviding {
    func loadCities() async throws -> [City]
}

/// Источник рейсов между двумя точками маршрута
protocol RouteProviding {
    func loadSegments(from: RoutePoint, to: RoutePoint) async throws -> [RouteSegment]
}

/// Города из макета. Задержка имитирует сетевой запрос,
/// режим симуляции ошибки переключается на экране настроек.
struct MockCityProvider: CityProviding {
    private let simulation: () -> ErrorSimulation

    init(simulation: @escaping () -> ErrorSimulation = { AppSettings.shared.errorSimulation }) {
        self.simulation = simulation
    }

    func loadCities() async throws -> [City] {
        try await Task.sleep(nanoseconds: 300_000_000)
        if let error = simulation().error {
            throw error
        }
        return MockData.cities
    }
}

/// Рейсы из макета. Список одинаков для любой пары станций —
/// в этом спринте важна вёрстка, а не подбор расписания.
struct MockRouteProvider: RouteProviding {
    private let simulation: () -> ErrorSimulation

    init(simulation: @escaping () -> ErrorSimulation = { AppSettings.shared.errorSimulation }) {
        self.simulation = simulation
    }

    func loadSegments(from: RoutePoint, to: RoutePoint) async throws -> [RouteSegment] {
        try await Task.sleep(nanoseconds: 300_000_000)
        if let error = simulation().error {
            throw error
        }
        return MockData.segments
    }
}
