import SwiftUI

/// Полноэкранный выбор точки маршрута: город, затем станция.
/// Показывается поверх таббара, стрелка на первом экране закрывает выбор.
struct RoutePointPickerView: View {
    @State private var path: [City] = []

    let onSelect: (RoutePoint) -> Void

    var body: some View {
        NavigationStack(path: $path) {
            CityListView { city in
                path.append(city)
            }
            .navigationDestination(for: City.self) { city in
                StationListView(city: city) { station in
                    onSelect(RoutePoint(city: city, station: station))
                }
            }
        }
    }
}

#Preview {
    RoutePointPickerView { _ in }
}
