import Foundation

/// Населённый пункт со списком станций
struct City: Identifiable, Hashable, Sendable {
    let id: String
    let name: String
    let stations: [Station]
}

/// Станция (вокзал) внутри города
struct Station: Identifiable, Hashable, Sendable {
    let id: String
    let name: String
}

/// Точка маршрута — город вместе с выбранной станцией
struct RoutePoint: Hashable, Sendable {
    let city: City
    let station: Station

    /// «Москва (Курский вокзал)» — так точка подписана на главном экране
    var title: String {
        "\(city.name) (\(station.name))"
    }
}
