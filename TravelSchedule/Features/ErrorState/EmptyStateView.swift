import SwiftUI

/// Надпись по центру экрана, когда список пуст: «Вариантов нет», «Город не найден»
struct EmptyStateView: View {
    let text: String

    var body: some View {
        Text(text)
            .appFont(.bold24)
            .foregroundStyle(Color.ypBlack)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    EmptyStateView(text: "Вариантов нет")
        .background(Color.ypWhite)
}
