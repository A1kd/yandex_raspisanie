import SwiftUI

/// Полноэкранный просмотр историй.
/// Истории листаются свайпом и тапом по сторонам экрана, идут по 10 секунд
/// и закрываются крестиком, свайпом вниз или после последней истории.
struct StoriesView: View {
    @StateObject private var viewModel: StoriesViewModel
    @ObservedObject private var settings = AppSettings.shared

    /// Позиция карточки на главном экране — из неё разворачивается просмотр
    private let origin: CGRect
    private let onClose: () -> Void

    /// Насколько далеко утащили экран вниз, чтобы закрыть
    @State private var dragTranslation: CGSize = .zero
    @State private var isExpanded = false

    /// Ниже этой границы свайп вниз закрывает экран
    private let dismissDistance: CGFloat = 120
    /// Начиная с этого сдвига свайп в сторону листает истории
    private let switchDistance: CGFloat = 60
    private let openDuration: TimeInterval = 0.3

    init(
        stories: [Story] = StoriesData.all,
        startIndex: Int,
        origin: CGRect = .zero,
        onClose: @escaping () -> Void
    ) {
        _viewModel = StateObject(
            wrappedValue: StoriesViewModel(stories: stories, startIndex: startIndex)
        )
        self.origin = origin
        self.onClose = onClose
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.ypBlackUniversal
                    .ignoresSafeArea()
                    .opacity(isExpanded ? 1 : 0)

                content(size: geometry.size)
                    .scaleEffect(isExpanded ? 1 : 0.2, anchor: anchor(in: geometry.size))
                    .opacity(isExpanded ? 1 : 0)
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            viewModel.onFinish = close
            viewModel.start()
            withAnimation(.easeOut(duration: openDuration)) {
                isExpanded = true
            }
        }
        .onDisappear(perform: viewModel.stop)
        .onChange(of: viewModel.currentIndex, initial: true) { _, index in
            guard viewModel.stories.indices.contains(index) else { return }
            settings.markStorySeen(viewModel.stories[index].id)
        }
    }

    private func content(size: CGSize) -> some View {
        currentPage
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 40))
            .overlay(alignment: .top) { controls }
            .scaleEffect(dismissProgress.isZero ? 1 : 1 - dismissProgress * 0.15)
            .offset(y: max(dragTranslation.height, 0))
            .contentShape(Rectangle())
            .onTapGesture { location in
                if location.x < size.width / 3 {
                    viewModel.showPrevious()
                } else {
                    viewModel.showNext()
                }
            }
            .gesture(dragGesture)
    }

    /// Показывается одна история, соседние выезжают с той стороны, куда листают
    @ViewBuilder
    private var currentPage: some View {
        if let story = viewModel.currentStory {
            StoryPageView(story: story)
                .id(story.id)
                .offset(x: horizontalDrag)
                .transition(
                    .asymmetric(
                        insertion: .move(edge: viewModel.isForward ? .trailing : .leading),
                        removal: .move(edge: viewModel.isForward ? .leading : .trailing)
                    )
                )
                .animation(.easeInOut(duration: 0.25), value: viewModel.currentIndex)
        }
    }

    private var controls: some View {
        VStack(spacing: 16) {
            StoriesProgressBar(
                count: viewModel.stories.count,
                currentIndex: viewModel.currentIndex,
                progress: viewModel.progress
            )

            HStack {
                Spacer()
                closeButton
            }
        }
        .padding(.horizontal, 12)
        .padding(.top, 28)
    }

    private var closeButton: some View {
        Button(action: close) {
            Image("icClose")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundStyle(Color.ypWhiteUniversal)
                .padding(3)
                .background(Circle().fill(Color.ypBlackUniversal))
        }
        .accessibilityLabel("Закрыть")
        .accessibilityIdentifier("stories-close")
    }

    /// Живой сдвиг историй за пальцем — только вбок и только внутри списка
    private var horizontalDrag: CGFloat {
        guard abs(dragTranslation.width) > abs(dragTranslation.height) else { return 0 }
        let isFirst = viewModel.currentIndex == 0 && dragTranslation.width > 0
        let isLast = viewModel.currentIndex == viewModel.stories.count - 1 && dragTranslation.width < 0
        return isFirst || isLast ? dragTranslation.width / 4 : dragTranslation.width
    }

    /// Насколько экран утащили вниз: 0 — не тронут, 1 — дошли до границы закрытия
    private var dismissProgress: CGFloat {
        min(max(dragTranslation.height, 0) / dismissDistance, 1)
    }

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                dragTranslation = value.translation
            }
            .onEnded { value in
                let translation = value.translation
                dragTranslation = .zero

                if translation.height > dismissDistance,
                   translation.height > abs(translation.width) {
                    close()
                } else if translation.width < -switchDistance {
                    viewModel.showNext()
                } else if translation.width > switchDistance {
                    viewModel.showPrevious()
                }
            }
    }

    /// Точка, из которой разворачивается экран — центр карточки на главном
    private func anchor(in size: CGSize) -> UnitPoint {
        guard origin != .zero, size.width > 0, size.height > 0 else { return .center }
        return UnitPoint(x: origin.midX / size.width, y: origin.midY / size.height)
    }

    private func close() {
        viewModel.stop()
        withAnimation(.easeIn(duration: 0.2)) {
            isExpanded = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: onClose)
    }
}

#Preview {
    StoriesView(startIndex: 0) {}
}
