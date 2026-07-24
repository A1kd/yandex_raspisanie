import SwiftUI

/// Экран выбора станции в выбранном городе
struct StationListView: View {
    @StateObject private var viewModel: StationListViewModel
    @Environment(\.dismiss) private var dismiss

    let onSelect: (Station) -> Void

    init(city: City, onSelect: @escaping (Station) -> Void) {
        _viewModel = StateObject(wrappedValue: StationListViewModel(city: city))
        self.onSelect = onSelect
    }

    var body: some View {
        VStack(spacing: 0) {
            SearchField(text: $viewModel.searchText)

            if viewModel.filteredStations.isEmpty {
                EmptyStateView(text: "Станция не найдена")
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(viewModel.filteredStations) { station in
                            Button {
                                onSelect(station)
                            } label: {
                                ListRow(title: station.name)
                            }
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.ypWhite)
        .appNavigationBar(title: "Выбор станции") { dismiss() }
    }
}

#Preview {
    NavigationStack {
        StationListView(city: MockData.cities[0]) { _ in }
    }
}
