import SwiftUI

/// Палитра из макета (UI-kit → Colors).
/// ypBlack и ypWhite — динамическая пара: в тёмной теме они меняются местами.
/// Остальные цвета одинаковы в обеих темах.
extension Color {
    /// #1A1B22 днём, #FFFFFF ночью — основной цвет текста и иконок
    static let ypBlack = Color("ypBlack")
    /// #FFFFFF днём, #1A1B22 ночью — основной фон
    static let ypWhite = Color("ypWhite")
    /// #3772E7 — акцент: кнопки, рамка сторис, ссылки
    static let ypBlue = Color("ypBlue")
    /// #AEAFB4 — второстепенный текст, разделители, неактивная вкладка
    static let ypGray = Color("ypGray")
    /// #F56B6C — пометка о пересадке
    static let ypRed = Color("ypRed")
    /// #EEEEEE — фон карточки рейса, одинаков в обеих темах
    static let ypLightGray = Color("ypLightGray")
    /// #1A1B22 в обеих темах — текст на светлых карточках
    static let ypBlackUniversal = Color("ypBlackUniversal")
    /// #FFFFFF в обеих темах — текст на кнопках и поле направления
    static let ypWhiteUniversal = Color("ypWhiteUniversal")
    /// Фон поля поиска: #EEEEEE днём, #767680 с прозрачностью 24% ночью
    static let ypSearchField = Color("ypSearchField")
}
