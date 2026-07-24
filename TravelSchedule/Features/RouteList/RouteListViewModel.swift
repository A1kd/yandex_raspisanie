import Combine
import Foundation

/// Список рейсов между двумя точками с учётом выбранных фильтров
@MainActor
final class RouteListViewModel: ObservableObject {
    @Published private(set) var state: LoadState<[RouteSegment]> = .loading
    @Published var filter = RouteFilter()

    let from: RoutePoint
    let to: RoutePoint

    private let provider: RouteProviding

    init(
        from: RoutePoint,
        to: RoutePoint,
        filter: RouteFilter = RouteFilter(),
        provider: RouteProviding = MockRouteProvider()
    ) {
        self.from = from
        self.to = to
        self.filter = filter
        self.provider = provider
    }

    /// «Москва (Ярославский вокзал) → Санкт Петербург (Балтийский вокзал)»
    var title: String {
        "\(from.title) → \(to.title)"
    }

    /// Рейсы, прошедшие фильтр
    var segments: [RouteSegment] {
        guard case .loaded(let segments) = state else { return [] }
        return segments.filter(filter.matches)
    }

    var hasActiveFilter: Bool {
        !filter.isEmpty
    }

    func load() async {
        state = .loading
        do {
            let segments = try await provider.loadSegments(from: from, to: to)
            state = .loaded(segments)
        } catch let error as AppError {
            state = .failed(error)
        } catch {
            state = .failed(.serverError)
        }
    }
}
