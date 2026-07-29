import Foundation

/// Превращает ответ /search/ в карточки рейсов
enum SegmentsMapper {

    static func segments(from response: SearchSegments) -> [RouteSegment] {
        let formatter = ISO8601DateFormatter()
        return (response.segments ?? []).compactMap { segment(from: $0, formatter: formatter) }
    }

    private static func segment(
        from segment: Components.Schemas.Segment,
        formatter: ISO8601DateFormatter
    ) -> RouteSegment? {
        guard
            let departureText = segment.departure,
            let arrivalText = segment.arrival,
            let departure = formatter.date(from: departureText),
            let arrival = formatter.date(from: arrivalText),
            let carrier = carrier(from: segment)
        else { return nil }

        return RouteSegment(
            id: "\(threadUID(of: segment))-\(departureText)",
            carrier: carrier,
            departure: departure,
            arrival: arrival,
            transferPlace: transferPlace(of: segment)
        )
    }

    /// У обычного рейса перевозчик лежит в нитке, у маршрута с пересадками
    /// нитки нет — берём перевозчика первого отрезка из details
    private static func carrier(from segment: Components.Schemas.Segment) -> Carrier? {
        let apiCarrier = segment.thread?.carrier
            ?? segment.details?.compactMap { $0.thread?.carrier }.first

        guard let apiCarrier, let title = apiCarrier.title, !title.isEmpty else { return nil }

        return Carrier(
            id: apiCarrier.code.map(String.init) ?? title,
            title: title,
            fullTitle: title,
            logoName: nil,
            logoURL: (apiCarrier.logo?.isEmpty == false) ? apiCarrier.logo.flatMap(URL.init(string:)) : nil,
            bannerName: nil,
            email: apiCarrier.email ?? "",
            phone: apiCarrier.phone ?? ""
        )
    }

    private static func transferPlace(of segment: Components.Schemas.Segment) -> String? {
        guard segment.has_transfers == true else { return nil }
        return segment.transfers?.first?.title
    }

    private static func threadUID(of segment: Components.Schemas.Segment) -> String {
        if let uid = segment.thread?.uid {
            return uid
        }
        let uids = (segment.details ?? []).compactMap { $0.thread?.uid }
        return uids.isEmpty ? "transfer" : uids.joined(separator: "+")
    }
}
