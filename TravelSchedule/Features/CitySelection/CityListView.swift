import SwiftUI

/// Экран выбора города: поиск по мере ввода и список населённых пунктов
struct CityListView: View {
    @StateObject private var viewModel = CityListViewModel()
    @Environment(\.dismiss) private var dismiss

    let onSelect: (City) -> Void

    var body: some View {
        VStack(spacing: 0) {
            SearchField(text: $viewModel.searchText)

            switch viewModel.state {
            case .loading:
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

            case .failed(let error):
                ErrorView(error: error)

            case .loaded:
                if viewModel.filteredCities.isEmpty {
                    EmptyStateView(text: "Город не найден")
                } else {
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(viewModel.filteredCities) { city in
                                Button {
                                    onSelect(city)
                                } label: {
                                    ListRow(title: city.name)
                                }
                            }
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.ypWhite)
        .appNavigationBar(title: "Выбор города") { dismiss() }
        .task {
            await viewModel.load()
        }
    }
}

#Preview {
    NavigationStack {
        CityListView { _ in }
    }
}
