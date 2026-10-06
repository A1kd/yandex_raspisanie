import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

/// Единая точка входа в сетевой слой: actor с методом на каждый
/// из восьми сервисов API «Яндекс Расписаний».
///
/// Сам по себе actor лишь сериализует доступ к своему состоянию.
/// Из-за реентерабельности две задачи могут одновременно «провалиться»
/// в один и тот же await и запустить работу дважды, поэтому кэш городов
/// хранится как Task: повторный вызов дожидается уже запущенной загрузки,
/// а не начинает новую.
actor NetworkClient {
    static let shared = NetworkClient()

    private let apikey: String
    private var client: Client?

    /// Загрузка городов: stations_list весит ~35 МБ, поэтому результат
    /// разбирается один раз и переиспользуется всеми экранами.
    private var citiesTask: Task<[City], Error>?

    init(apikey: String = APIConstants.apikey) {
        self.apikey = apikey
    }

    // MARK: - Сервисы

    func nearestStations(lat: Double, lng: Double, distance: Int) async throws -> NearestStations {
        try await NearestStationsService(client: makeClient(), apikey: apikey)
            .getNearestStations(lat: lat, lng: lng, distance: distance)
    }

    func searchRoutes(from: String, to: String, date: String?, transfers: Bool?) async throws -> SearchSegments {
        try await SearchService(client: makeClient(), apikey: apikey)
            .getScheduleBetweenStations(from: from, to: to, date: date, transfers: transfers)
    }

    func stationSchedule(station: String) async throws -> StationSchedule {
        try await StationScheduleService(client: makeClient(), apikey: apikey)
            .getStationSchedule(station: station)
    }

    func routeStations(uid: String) async throws -> RouteStations {
        try await RouteStationsService(client: makeClient(), apikey: apikey)
            .getRouteStations(uid: uid)
    }

    func nearestSettlement(lat: Double, lng: Double) async throws -> NearestSettlement {
        try await NearestSettlementService(client: makeClient(), apikey: apikey)
            .getNearestSettlement(lat: lat, lng: lng)
    }

    func carrierInfo(code: String, system: String) async throws -> CarrierInfo {
        try await CarrierService(client: makeClient(), apikey: apikey)
            .getCarrierInfo(code: code, system: system)
    }

    func copyright() async throws -> Copyright {
        try await CopyrightService(client: makeClient(), apikey: apikey)
            .getCopyright()
    }

    func allStations() async throws -> AllStations {
        try await StationsListService(client: makeClient(), apikey: apikey)
            .getAllStations()
    }

    // MARK: - Города с кэшем

    func cities() async throws -> [City] {
        if let citiesTask {
            return try await citiesTask.value
        }
        let task = Task {
            StationsMapper.cities(from: try await self.allStations())
        }
        citiesTask = task
        do {
            return try await task.value
        } catch {
            // Неудачная загрузка не кэшируется — следующий вызов попробует снова
            citiesTask = nil
            throw error
        }
    }

    // MARK: - Клиент

    private func makeClient() throws -> Client {
        if let client {
            return client
        }
        let created = Client(
            serverURL: try Servers.Server1.url(),
            transport: URLSessionTransport()
        )
        client = created
        return created
    }
}
