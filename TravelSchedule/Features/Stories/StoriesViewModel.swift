import Combine
import Foundation

/// Проигрывает истории по очереди: каждая держится на экране 10 секунд,
/// после последней экран закрывается.
final class StoriesViewModel: ObservableObject {
    /// Сколько показывается одна история — по техническому заданию
    static let storyDuration: TimeInterval = 10
    /// Как часто подрастает индикатор
    private static let tickInterval: TimeInterval = 0.05

    let stories: [Story]

    @Published var currentIndex: Int {
        didSet {
            guard currentIndex != oldValue else { return }
            progress = 0
        }
    }

    @Published private(set) var progress: CGFloat = 0

    /// Куда листали в последний раз — от этого зависит, с какой стороны выезжает история
    @Published private(set) var isForward = true

    /// Вызывается, когда истории закончились или пользователь их закрыл
    var onFinish: () -> Void = {}

    private var timer: AnyCancellable?

    init(stories: [Story], startIndex: Int) {
        self.stories = stories
        currentIndex = min(max(startIndex, 0), max(stories.count - 1, 0))
    }

    var currentStory: Story? {
        stories.indices.contains(currentIndex) ? stories[currentIndex] : nil
    }

    func start() {
        timer = Timer.publish(every: Self.tickInterval, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.tick()
            }
    }

    func stop() {
        timer?.cancel()
        timer = nil
    }

    /// Следующая история, а после последней — закрытие экрана
    func showNext() {
        guard currentIndex + 1 < stories.count else {
            onFinish()
            return
        }
        isForward = true
        currentIndex += 1
    }

    /// Предыдущая история, с первой — просто перезапуск показа
    func showPrevious() {
        guard currentIndex > 0 else {
            progress = 0
            return
        }
        isForward = false
        currentIndex -= 1
    }

    private func tick() {
        let step = CGFloat(Self.tickInterval / Self.storyDuration)
        if progress + step >= 1 {
            showNext()
        } else {
            progress += step
        }
    }
}
