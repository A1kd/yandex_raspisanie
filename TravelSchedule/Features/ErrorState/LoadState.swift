import Foundation

/// Состояние экрана, который грузит данные
enum LoadState<Value> {
    case loading
    case loaded(Value)
    case failed(AppError)
}
