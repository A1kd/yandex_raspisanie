import Combine
import Foundation

/// Список городов с поиском по мере ввода
@MainActor
final class CityListViewModel: ObservableObject {
    @Published var searchText = ""
    @Published private(set) var state: LoadState<[City]> = .loading

    private let provider: CityProviding

    init(provider: CityProviding = MockCityProvider()) {
        self.provider = provider
    }

    /// Города, подходящие под запрос
    var filteredCities: [City] {
        guard case .loaded(let cities) = state else { return [] }
        guard !searchText.isEmpty else { return cities }
        return cities.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    func load() async {
        state = .loading
        do {
            let cities = try await provider.loadCities()
            state = .loaded(cities)
        } catch let error as AppError {
            state = .failed(error)
        } catch {
            state = .failed(.serverError)
        }
    }
}
