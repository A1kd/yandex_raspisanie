import SwiftUI

/// Список рейсов между выбранными станциями
struct RouteListView: View {
    @StateObject private var viewModel: RouteListViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var isFiltersShown = false
    @State private var selectedCarrier: Carrier?

    init(
        from: RoutePoint,
        to: RoutePoint,
        initialFilter: RouteFilter = RouteFilter(),
        provider: RouteProviding = MockRouteProvider()
    ) {
        _viewModel = StateObject(
            wrappedValue: RouteListViewModel(
                from: from,
                to: to,
                filter: initialFilter,
                provider: provider
            )
        )
    }

    var body: some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.ypWhite)
            .appNavigationBar { dismiss() }
            .navigationDestination(isPresented: $isFiltersShown) {
                FiltersView(filter: $viewModel.filter)
            }
            .navigationDestination(item: $selectedCarrier) { carrier in
                CarrierCardView(carrier: carrier)
            }
            .task {
                await viewModel.load()
            }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .failed(let error):
            ErrorView(error: error)

        case .loaded:
            loadedContent
        }
    }

    private var loadedContent: some View {
        VStack(spacing: 16) {
            Text(viewModel.title)
                .appFont(.bold24)
                .foregroundStyle(Color.ypBlack)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)

            ZStack(alignment: .bottom) {
                if viewModel.segments.isEmpty {
                    EmptyStateView(text: "Вариантов нет")
                } else {
                    ScrollView {
                        LazyVStack(spacing: 8) {
                            ForEach(viewModel.segments) { segment in
                                Button {
                                    selectedCarrier = segment.carrier
                                } label: {
                                    RouteCard(segment: segment)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 84)
                    }
                    .scrollIndicators(.hidden)
                }

                PrimaryButton(
                    title: "Уточнить время",
                    showsIndicator: viewModel.hasActiveFilter
                ) {
                    isFiltersShown = true
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
        }
        .padding(.top, 16)
    }
}

#Preview {
    NavigationStack {
        RouteListView(
            from: RoutePoint(city: MockData.cities[0], station: MockData.cities[0].stations[2]),
            to: RoutePoint(city: MockData.cities[1], station: MockData.cities[1].stations[0])
        )
    }
}
