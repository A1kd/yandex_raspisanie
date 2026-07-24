import SwiftUI

/// Синяя кнопка из макета: высота 60, скругление 16, текст Bold/17.
/// `style` задаёт ширину: длинная кнопка тянется на всю ширину,
/// короткая («Найти») занимает 150 точек.
struct PrimaryButton: View {
    enum Style {
        case long
        case short
    }

    let title: String
    var style: Style = .long
    /// Красная точка справа от текста — признак применённых фильтров
    var showsIndicator: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Text(title)
                    .appFont(.bold17)
                    .foregroundStyle(Color.ypWhiteUniversal)

                if showsIndicator {
                    Circle()
                        .fill(Color.ypRed)
                        .frame(width: 8, height: 8)
                }
            }
            .frame(maxWidth: style == .long ? .infinity : nil)
            .frame(width: style == .short ? 150 : nil, height: 60)
            .background(Color.ypBlue)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        PrimaryButton(title: "Найти", style: .short) {}
        PrimaryButton(title: "Уточнить время", showsIndicator: true) {}
        PrimaryButton(title: "Применить") {}
    }
    .padding(16)
    .background(Color.ypWhite)
}
