import Combine
import Foundation

/// Карточка перевозчика: контакты и ссылки для перехода в почту и звонилку
@MainActor
final class CarrierCardViewModel: ObservableObject {
    let carrier: Carrier

    init(carrier: Carrier) {
        self.carrier = carrier
    }

    var hasEmail: Bool {
        !carrier.email.isEmpty
    }

    var hasPhone: Bool {
        !carrier.phone.isEmpty
    }

    var emailURL: URL? {
        URL(string: "mailto:\(carrier.email)")
    }

    /// Номер без скобок и дефисов — в таком виде его принимает звонилка
    var phoneURL: URL? {
        let digits = carrier.phone.filter { $0.isNumber || $0 == "+" }
        return URL(string: "tel:\(digits)")
    }
}
