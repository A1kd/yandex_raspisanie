import Combine
import Foundation

/// Список станций выбранного города с поиском по мере ввода
@MainActor
final class StationListViewModel: ObservableObject {
    @Published var searchText = ""

    let city: City

    init(city: City) {
        self.city = city
    }

    var filteredStations: [Station] {
        guard !searchText.isEmpty else { return city.stations }
        return city.stations.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
}
