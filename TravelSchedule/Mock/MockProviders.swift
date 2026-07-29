import Foundation

/// Города из макета для превью. Задержка имитирует сетевой запрос,
/// через simulation можно посмотреть экраны ошибок.
struct MockCityProvider: CityProviding {
    private let simulation: ErrorSimulation

    init(simulation: ErrorSimulation = .none) {
        self.simulation = simulation
    }

    func loadCities() async throws -> [City] {
        try await Task.sleep(nanoseconds: 300_000_000)
        if let error = simulation.error {
            throw error
        }
        return MockData.cities
    }
}

/// Рейсы из макета для превью. Список одинаков для любой пары станций.
struct MockRouteProvider: RouteProviding {
    private let simulation: ErrorSimulation

    init(simulation: ErrorSimulation = .none) {
        self.simulation = simulation
    }

    func loadSegments(from: RoutePoint, to: RoutePoint) async throws -> [RouteSegment] {
        try await Task.sleep(nanoseconds: 300_000_000)
        if let error = simulation.error {
            throw error
        }
        return MockData.segments
    }
}
