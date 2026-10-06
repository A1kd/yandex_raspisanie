import Combine
import Foundation

/// Пользовательское соглашение: отдаёт адрес свёрстанной оферты из бандла
@MainActor
final class AgreementViewModel: ObservableObject {
    let offerURL = Bundle.main.url(forResource: "offer", withExtension: "html")
}
