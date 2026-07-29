import Foundation

/// Состояние экрана, который грузит данные
enum LoadState<Value: Sendable>: Sendable {
    case loading
    case loaded(Value)
    case failed(AppError)
}
