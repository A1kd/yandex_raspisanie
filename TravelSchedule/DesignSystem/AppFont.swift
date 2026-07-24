import SwiftUI

/// Текстовые стили из макета (UI-kit → Text Styles).
/// Кегль, начертание и трекинг взяты из Figma один в один.
enum AppFont {
    case regular12
    case regular17
    case regular20
    case bold17
    case bold24
    case bold34

    var font: Font {
        switch self {
        case .regular12: return .system(size: 12, weight: .regular)
        case .regular17: return .system(size: 17, weight: .regular)
        case .regular20: return .system(size: 20, weight: .regular)
        case .bold17: return .system(size: 17, weight: .bold)
        case .bold24: return .system(size: 24, weight: .bold)
        case .bold34: return .system(size: 34, weight: .bold)
        }
    }

    var tracking: CGFloat {
        switch self {
        case .regular12, .regular20, .bold34: return 0.4
        case .regular17: return -0.408
        case .bold17, .bold24: return 0
        }
    }
}

extension View {
    /// Применяет кегль и трекинг текстового стиля из макета
    func appFont(_ style: AppFont) -> some View {
        font(style.font).tracking(style.tracking)
    }
}
