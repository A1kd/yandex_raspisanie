import Foundation

/// История из панели Stories на главном экране.
/// Картинка и тексты статичные — берутся из макета.
struct Story: Identifiable, Hashable, Sendable {
    let id: Int
    /// Имя картинки в Assets — она же в превью и на полном экране
    let imageName: String
    /// Подпись на карточке в панели, три строки
    let previewText: String
    /// Заголовок на полном экране
    let title: String
    /// Описание под заголовком
    let text: String
}
