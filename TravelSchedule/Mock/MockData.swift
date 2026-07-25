import Foundation

/// Данные из макета: города, станции, перевозчики и рейсы.
/// В следующем спринте вместо них подставляются ответы API.
enum MockData {

    // MARK: - Перевозчики

    static let rzd = Carrier(
        id: "rzd",
        title: "РЖД",
        fullTitle: "ОАО «РЖД»",
        logoName: "brandRZD",
        bannerName: "logoRZD",
        email: "i.lozgkina@yandex.ru",
        phone: "+7 (904) 329-27-71"
    )

    static let fgk = Carrier(
        id: "fgk",
        title: "ФГК",
        fullTitle: "АО «ФГК»",
        logoName: "brandFGK",
        bannerName: nil,
        email: "info@fgk.ru",
        phone: "+7 (495) 663-01-01"
    )

    static let ural = Carrier(
        id: "ural",
        title: "Урал логистика",
        fullTitle: "ООО «Урал логистика»",
        logoName: "brandUral",
        bannerName: nil,
        email: "info@ural-logistika.ru",
        phone: "+7 (343) 222-33-44"
    )

    static let carriers: [Carrier] = [rzd, fgk, ural]

    // MARK: - Города и станции

    static let cities: [City] = [
        City(id: "c213", name: "Москва", stations: [
            Station(id: "s2000001", name: "Киевский вокзал"),
            Station(id: "s2000002", name: "Курский вокзал"),
            Station(id: "s2000003", name: "Ярославский вокзал"),
            Station(id: "s2000004", name: "Белорусский вокзал"),
            Station(id: "s2000005", name: "Савеловский вокзал"),
            Station(id: "s2000006", name: "Ленинградский вокзал")
        ]),
        City(id: "c2", name: "Санкт Петербург", stations: [
            Station(id: "s2000007", name: "Балтийский вокзал"),
            Station(id: "s2000008", name: "Московский вокзал"),
            Station(id: "s2000009", name: "Ладожский вокзал"),
            Station(id: "s2000010", name: "Финляндский вокзал"),
            Station(id: "s2000011", name: "Витебский вокзал")
        ]),
        City(id: "c239", name: "Сочи", stations: [
            Station(id: "s2000012", name: "Вокзал Сочи"),
            Station(id: "s2000013", name: "Вокзал Адлер"),
            Station(id: "s2000014", name: "Вокзал Лазаревская")
        ]),
        City(id: "c11326", name: "Горный воздух", stations: [
            Station(id: "s2000015", name: "Станция Горный воздух")
        ]),
        City(id: "c35", name: "Краснодар", stations: [
            Station(id: "s2000016", name: "Вокзал Краснодар 1"),
            Station(id: "s2000017", name: "Вокзал Краснодар 2")
        ]),
        City(id: "c43", name: "Казань", stations: [
            Station(id: "s2000018", name: "Вокзал Казань 1"),
            Station(id: "s2000019", name: "Вокзал Восстание Пассажирская")
        ]),
        City(id: "c66", name: "Омск", stations: [
            Station(id: "s2000020", name: "Вокзал Омск Пассажирский")
        ])
    ]

    // MARK: - Рейсы

    static let segments: [RouteSegment] = [
        RouteSegment(
            id: "1",
            carrier: rzd,
            departure: date(day: 14, hour: 22, minute: 30),
            arrival: date(day: 15, hour: 8, minute: 15),
            transferPlace: "Костроме"
        ),
        RouteSegment(
            id: "2",
            carrier: fgk,
            departure: date(day: 15, hour: 1, minute: 15),
            arrival: date(day: 15, hour: 9, minute: 0),
            transferPlace: nil
        ),
        RouteSegment(
            id: "3",
            carrier: ural,
            departure: date(day: 16, hour: 12, minute: 30),
            arrival: date(day: 16, hour: 21, minute: 0),
            transferPlace: nil
        ),
        RouteSegment(
            id: "4",
            carrier: rzd,
            departure: date(day: 17, hour: 22, minute: 30),
            arrival: date(day: 18, hour: 8, minute: 15),
            transferPlace: "Костроме"
        ),
        RouteSegment(
            id: "5",
            carrier: rzd,
            departure: date(day: 17, hour: 22, minute: 30),
            arrival: date(day: 18, hour: 8, minute: 15),
            transferPlace: nil
        ),
        RouteSegment(
            id: "6",
            carrier: fgk,
            departure: date(day: 18, hour: 7, minute: 45),
            arrival: date(day: 18, hour: 16, minute: 30),
            transferPlace: nil
        ),
        RouteSegment(
            id: "7",
            carrier: ural,
            departure: date(day: 19, hour: 19, minute: 10),
            arrival: date(day: 20, hour: 6, minute: 40),
            transferPlace: "Ярославле"
        )
    ]

    /// Даты рейсов заданы в январе текущего года — как в макете
    private static func date(day: Int, hour: Int, minute: Int) -> Date {
        var components = DateComponents()
        components.year = Calendar.current.component(.year, from: Date())
        components.month = 1
        components.day = day
        components.hour = hour
        components.minute = minute
        return Calendar.current.date(from: components) ?? Date()
    }
}
