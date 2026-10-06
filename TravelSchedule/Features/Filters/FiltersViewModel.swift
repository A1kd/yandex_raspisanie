import Combine
import Foundation

/// Экран «Уточнить время»: собирает черновик фильтра,
/// который применяется к списку рейсов по кнопке «Применить»
@MainActor
final class FiltersViewModel: ObservableObject {
    @Published var draft: RouteFilter

    init(filter: RouteFilter) {
        draft = filter
    }

    /// Кнопка «Применить» появляется, когда выбран хотя бы один вариант
    var canApply: Bool {
        !draft.isEmpty
    }

    func toggle(_ interval: DepartureInterval) {
        if draft.intervals.contains(interval) {
            draft.intervals.remove(interval)
        } else {
            draft.intervals.insert(interval)
        }
    }

    func selectTransfers(_ value: Bool) {
        draft.showsTransfers = value
    }
}
