import SwiftUI

/// Строка списка из макета: высота 60, отступ 16 по краям,
/// заголовок слева и произвольный элемент справа.
struct ListRow<Trailing: View>: View {
    let title: String
    @ViewBuilder var trailing: Trailing

    var body: some View {
        HStack(spacing: 4) {
            Text(title)
                .appFont(.regular17)
                .foregroundStyle(Color.ypBlack)
                .lineLimit(1)

            Spacer(minLength: 4)

            trailing
                .frame(width: 24, height: 24)
        }
        .padding(.horizontal, 16)
        .frame(height: 60)
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
    }
}

extension ListRow where Trailing == ChevronIcon {
    /// Строка со стрелкой вправо — переход на следующий экран
    init(title: String) {
        self.init(title: title) { ChevronIcon() }
    }
}

/// Стрелка вправо из макета
struct ChevronIcon: View {
    var body: some View {
        Image("icChevron")
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .foregroundStyle(Color.ypBlack)
    }
}

#Preview {
    VStack(spacing: 0) {
        ListRow(title: "Москва")
        ListRow(title: "Санкт Петербург")
    }
    .background(Color.ypWhite)
}
