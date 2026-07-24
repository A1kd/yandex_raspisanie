import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

/// Примеры вызова каждого из 8 сервисов с минимальным набором параметров.
/// Результаты выводятся в консоль.
enum ServicesDemo {

    static func runAll() async {
        guard let client = makeClient() else { return }
        let apikey = APIConstants.apikey

        await testNearestStations(client: client, apikey: apikey)
        await testSearch(client: client, apikey: apikey)
        await testStationSchedule(client: client, apikey: apikey)
        await testRouteStations(client: client, apikey: apikey)
        await testNearestSettlement(client: client, apikey: apikey)
        await testCarrier(client: client, apikey: apikey)
        await testCopyright(client: client, apikey: apikey)
        await testStationsList(client: client, apikey: apikey)

        print("=== Проверка сервисов завершена ===")
    }

    private static func makeClient() -> Client? {
        do {
            return Client(
                serverURL: try Servers.Server1.url(),
                transport: URLSessionTransport()
            )
        } catch {
            print("Не удалось создать клиент: \(error)")
            return nil
        }
    }

    // 1. Список ближайших станций
    private static func testNearestStations(client: Client, apikey: String) async {
        do {
            let service = NearestStationsService(client: client, apikey: apikey)
            let stations = try await service.getNearestStations(
                lat: 59.864177,
                lng: 30.319163,
                distance: 50
            )
            print("1. getNearestStations: получено станций — \(stations.stations?.count ?? 0)")
        } catch {
            print("1. getNearestStations: ошибка — \(error)")
        }
    }

    // 2. Расписание рейсов между станциями (Москва -> Санкт-Петербург)
    private static func testSearch(client: Client, apikey: String) async {
        do {
            let service = SearchService(client: client, apikey: apikey)
            let segments = try await service.getScheduleBetweenStations(from: "c213", to: "c2")
            print("2. getScheduleBetweenStations: получено сегментов — \(segments.segments?.count ?? 0)")
        } catch {
            print("2. getScheduleBetweenStations: ошибка — \(error)")
        }
    }

    // 3. Список рейсов по станции (Шереметьево)
    private static func testStationSchedule(client: Client, apikey: String) async {
        do {
            let service = StationScheduleService(client: client, apikey: apikey)
            let schedule = try await service.getStationSchedule(station: "s9600213")
            print("3. getStationSchedule: рейсов на станции — \(schedule.schedule?.count ?? 0)")
        } catch {
            print("3. getStationSchedule: ошибка — \(error)")
        }
    }

    // 4. Список станций следования: uid берём из результата поиска, чтобы он был актуальным
    private static func testRouteStations(client: Client, apikey: String) async {
        do {
            let searchService = SearchService(client: client, apikey: apikey)
            let segments = try await searchService.getScheduleBetweenStations(from: "c213", to: "c2")
            guard let uid = segments.segments?.first?.thread?.uid else {
                print("4. getRouteStations: не удалось получить uid нитки из поиска")
                return
            }
            let service = RouteStationsService(client: client, apikey: apikey)
            let route = try await service.getRouteStations(uid: uid)
            print("4. getRouteStations: остановок на маршруте «\(route.title ?? "?")» — \(route.stops?.count ?? 0)")
        } catch {
            print("4. getRouteStations: ошибка — \(error)")
        }
    }

    // 5. Ближайший город
    private static func testNearestSettlement(client: Client, apikey: String) async {
        do {
            let service = NearestSettlementService(client: client, apikey: apikey)
            let settlement = try await service.getNearestSettlement(lat: 59.864177, lng: 30.319163)
            print("5. getNearestSettlement: ближайший город — \(settlement.title ?? "?")")
        } catch {
            print("5. getNearestSettlement: ошибка — \(error)")
        }
    }

    // 6. Информация о перевозчике (Аэрофлот, код IATA)
    private static func testCarrier(client: Client, apikey: String) async {
        do {
            let service = CarrierService(client: client, apikey: apikey)
            let info = try await service.getCarrierInfo(code: "SU", system: "iata")
            print("6. getCarrierInfo: перевозчик — \(info.carriers?.first?.title ?? "?")")
        } catch {
            print("6. getCarrierInfo: ошибка — \(error)")
        }
    }

    // 7. Копирайт
    private static func testCopyright(client: Client, apikey: String) async {
        do {
            let service = CopyrightService(client: client, apikey: apikey)
            let copyright = try await service.getCopyright()
            print("7. getCopyright: \(copyright.copyright?.text ?? "?")")
        } catch {
            print("7. getCopyright: ошибка — \(error)")
        }
    }

    // 8. Список всех станций (ответ ~40 МБ, выполняется дольше остальных)
    private static func testStationsList(client: Client, apikey: String) async {
        do {
            let service = StationsListService(client: client, apikey: apikey)
            let allStations = try await service.getAllStations()
            print("8. getAllStations: стран в списке — \(allStations.countries?.count ?? 0)")
        } catch {
            print("8. getAllStations: ошибка — \(error)")
        }
    }
}
