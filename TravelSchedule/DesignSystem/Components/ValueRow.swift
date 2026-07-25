import SwiftUI

/// Строка списка с подписью: заголовок Regular/17 и значение Regular/12 синим.
/// В макете так показаны контакты перевозчика.
struct ValueRow: View {
    let title: String
    let value: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 0) {
                Text(title)
                    .appFont(.regular17)
                    .foregroundStyle(Color.ypBlack)

                Text(value)
                    .appFont(.regular12)
                    .foregroundStyle(Color.ypBlue)
            }
            .lineLimit(1)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .frame(height: 60)
            .contentShape(Rectangle())
        }
    }
}

#Preview {
    VStack(spacing: 0) {
        ValueRow(title: "E-mail", value: "i.lozgkina@yandex.ru") {}
        ValueRow(title: "Телефон", value: "+7 (904) 329-27-71") {}
    }
    .background(Color.ypWhite)
}
