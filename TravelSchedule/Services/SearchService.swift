import OpenAPIRuntime
import OpenAPIURLSession

typealias SearchSegments = Components.Schemas.Segments

protocol SearchServiceProtocol {
    func getScheduleBetweenStations(
        from: String,
        to: String,
        date: String?,
        transfers: Bool?
    ) async throws -> SearchSegments
}

/// Расписание рейсов между станциями — /v3.0/search/
final class SearchService: SearchServiceProtocol {
    private let client: Client
    private let apikey: String

    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }

    func getScheduleBetweenStations(
        from: String,
        to: String,
        date: String? = nil,
        transfers: Bool? = nil
    ) async throws -> SearchSegments {
        let response = try await client.getSchedualBetweenStations(query: .init(
            apikey: apikey,
            from: from,
            to: to,
            lang: "ru_RU",
            date: date,
            transfers: transfers
        ))
        return try response.ok.body.json
    }
}
