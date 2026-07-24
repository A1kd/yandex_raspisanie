import OpenAPIRuntime
import OpenAPIURLSession

typealias NearestSettlement = Components.Schemas.NearestCityResponse

protocol NearestSettlementServiceProtocol {
    func getNearestSettlement(lat: Double, lng: Double) async throws -> NearestSettlement
}

/// Ближайший город — /v3.0/nearest_settlement/
final class NearestSettlementService: NearestSettlementServiceProtocol {
    private let client: Client
    private let apikey: String

    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }

    func getNearestSettlement(lat: Double, lng: Double) async throws -> NearestSettlement {
        let response = try await client.getNearestCity(query: .init(
            apikey: apikey,
            lat: lat,
            lng: lng
        ))
        return try response.ok.body.json
    }
}
