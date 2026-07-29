import Foundation

/// Превращает ответ stations_list в список городов с вокзалами
enum StationsMapper {

    /// Города России, в которых есть хотя бы один железнодорожный вокзал.
    /// Крупные города поднимаются наверх — как в макете, где список
    /// начинается с Москвы и Санкт-Петербурга.
    static func cities(from response: AllStations) -> [City] {
        let russia = (response.countries ?? []).first { $0.title == "Россия" }
        guard let regions = russia?.regions else { return [] }

        let cities = regions
            .flatMap { $0.settlements ?? [] }
            .compactMap(city(from:))

        return cities.sorted {
            if $0.stations.count != $1.stations.count {
                return $0.stations.count > $1.stations.count
            }
            return $0.name < $1.name
        }
    }

    private static func city(from settlement: Components.Schemas.Settlement) -> City? {
        guard
            let code = settlement.codes?.yandex_code,
            let name = settlement.title,
            !name.isEmpty
        else { return nil }

        let stations = (settlement.stations ?? []).compactMap(station(from:))
        guard !stations.isEmpty else { return nil }

        return City(id: code, name: name, stations: stations)
    }

    private static func station(from station: Components.Schemas.Station) -> Station? {
        guard
            station.station_type == "train_station",
            station.transport_type == "train",
            let code = station.codes?.yandex_code,
            let title = station.title,
            !title.isEmpty
        else { return nil }

        return Station(id: code, name: displayName(from: title))
    }

    /// В списке станция называется «Москва (Курский вокзал)» —
    /// внутри города достаточно названия вокзала из скобок
    private static func displayName(from title: String) -> String {
        guard
            let open = title.firstIndex(of: "("),
            let close = title.lastIndex(of: ")"),
            open < close
        else { return title }

        let name = title[title.index(after: open)..<close]
            .trimmingCharacters(in: .whitespaces)
        return name.isEmpty ? title : name
    }
}
