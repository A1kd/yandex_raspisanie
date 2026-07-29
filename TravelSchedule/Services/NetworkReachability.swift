import Foundation
import Network
import os

/// Проверка доступа к сети. NWPathMonitor умеет отдавать состояние
/// только через callback, поэтому он обёрнут в асинхронный метод
/// с помощью withCheckedContinuation.
enum NetworkReachability {

    /// true, если сеть доступна. По результату проверки ошибка запроса
    /// превращается в «Нет интернета» или «Ошибка сервера».
    static func isOnline() async -> Bool {
        await withCheckedContinuation { continuation in
            let monitor = NWPathMonitor()
            // Монитор может дёрнуть callback несколько раз, а continuation
            // разрешено возобновлять только однажды — флаг под замком
            // защищает от гонки между повторными вызовами.
            let hasResumed = OSAllocatedUnfairLock(initialState: false)

            monitor.pathUpdateHandler = { path in
                let alreadyResumed = hasResumed.withLock { resumed in
                    defer { resumed = true }
                    return resumed
                }
                guard !alreadyResumed else { return }
                monitor.cancel()
                continuation.resume(returning: path.status == .satisfied)
            }
            monitor.start(queue: DispatchQueue(label: "network.reachability"))
        }
    }
}
