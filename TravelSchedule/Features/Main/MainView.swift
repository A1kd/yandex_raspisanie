import SwiftUI

/// Главный экран: выбор направления и переход к списку рейсов
struct MainView: View {
    @StateObject private var viewModel: MainViewModel
    @State private var editingField: DirectionField?
    @State private var search: RouteSearch?

    init(initialFrom: RoutePoint? = nil, initialTo: RoutePoint? = nil) {
        _viewModel = StateObject(wrappedValue: MainViewModel(from: initialFrom, to: initialTo))
    }

    var body: some View {
        VStack(spacing: 16) {
            DirectionCard(
                from: viewModel.from,
                to: viewModel.to,
                onTapField: { editingField = $0 },
                onSwap: viewModel.swapDirections
            )

            if viewModel.canSearch {
                PrimaryButton(title: "Найти", style: .short) {
                    guard let from = viewModel.from, let to = viewModel.to else { return }
                    search = RouteSearch(from: from, to: to)
                }
            }

            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.ypWhite)
        .fullScreenCover(item: $editingField) { field in
            RoutePointPickerView { point in
                viewModel.select(point, for: field)
                editingField = nil
            }
        }
        .navigationDestination(item: $search) { search in
            RouteListView(from: search.from, to: search.to)
        }
    }
}

/// Параметры перехода к списку рейсов
struct RouteSearch: Identifiable, Hashable {
    let from: RoutePoint
    let to: RoutePoint

    var id: String { "\(from.station.id)-\(to.station.id)" }
}

#Preview {
    NavigationStack {
        MainView()
    }
}
