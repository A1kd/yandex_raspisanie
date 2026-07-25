import Foundation

/// Перевозчик: логотип для карточки рейса и контакты для экрана перевозчика
struct Carrier: Identifiable, Hashable {
    let id: String
    /// Короткое название в списке рейсов — «РЖД»
    let title: String
    /// Полное название на экране перевозчика — «ОАО «РЖД»»
    let fullTitle: String
    /// Имя картинки в Assets
    let logoName: String
    let email: String
    let phone: String
}
