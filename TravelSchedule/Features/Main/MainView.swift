import SwiftUI

/// Главный экран: истории, выбор направления и переход к списку рейсов
struct MainView: View {
    @StateObject private var viewModel: MainViewModel
    @ObservedObject private var settings = AppSettings.shared

    @State private var editingField: DirectionField?
    @State private var search: RouteSearch?
    @State private var openedStory: OpenedStory?

    init(initialFrom: RoutePoint? = nil, initialTo: RoutePoint? = nil) {
        _viewModel = StateObject(wrappedValue: MainViewModel(from: initialFrom, to: initialTo))
    }

    var body: some View {
        VStack(spacing: 0) {
            StoriesPanel(stories: StoriesData.all, seenStoryIDs: settings.seenStoryIDs) { index, frame in
                show(OpenedStory(index: index, origin: frame))
            }
            // Экран историй показывается со своей вьюхи: на одном экране
            // SwiftUI не показывает два fullScreenCover сразу
            .fullScreenCover(item: $openedStory) { story in
                StoriesView(startIndex: story.index, origin: story.origin) {
                    show(nil)
                }
            }

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
            }
            .padding(.horizontal, 16)
            .padding(.top, 20)

            Spacer()
        }
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

    /// Экран историй показывается без стандартного выезда снизу:
    /// вместо него истории разворачиваются из выбранной карточки
    private func show(_ story: OpenedStory?) {
        var transaction = Transaction()
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            openedStory = story
        }
    }
}

/// История, открытая из панели: с какой начинать показ и откуда её разворачивать
struct OpenedStory: Identifiable {
    let index: Int
    let origin: CGRect

    var id: Int { index }
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
