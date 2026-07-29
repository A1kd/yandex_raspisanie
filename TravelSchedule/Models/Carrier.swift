import Foundation

/// Перевозчик: логотип для карточки рейса и контакты для экрана перевозчика
struct Carrier: Identifiable, Hashable, Sendable {
    let id: String
    /// Короткое название в списке рейсов — «РЖД»
    let title: String
    /// Полное название на экране перевозчика — «ОАО «РЖД»»
    let fullTitle: String
    /// Имя картинки в Assets — для данных из макета
    let logoName: String?
    /// Ссылка на логотип из API — у части перевозчиков её нет
    let logoURL: URL?
    /// Широкий логотип для карточки перевозчика — есть не у всех
    let bannerName: String?
    let email: String
    let phone: String
}
