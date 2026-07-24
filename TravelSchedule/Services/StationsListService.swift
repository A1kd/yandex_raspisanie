import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

typealias AllStations = Components.Schemas.AllStationsResponse

protocol StationsListServiceProtocol {
    func getAllStations() async throws -> AllStations
}

/// Список всех доступных станций — /v3.0/stations_list/
/// Сервер отвечает с Content-Type text/html, поэтому тело собираем вручную
/// и декодируем как JSON.
final class StationsListService: StationsListServiceProtocol {
    private let client: Client
    private let apikey: String

    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }

    func getAllStations() async throws -> AllStations {
        let response = try await client.getAllStations(query: .init(apikey: apikey))
        let httpBody = try response.ok.body.text_html_charset_utf_hyphen_8

        // Ответ весит десятки мегабайт, ограничиваем сборку 50 МБ
        let data = try await Data(collecting: httpBody, upTo: 50 * 1024 * 1024)
        return try JSONDecoder().decode(AllStations.self, from: data)
    }
}
