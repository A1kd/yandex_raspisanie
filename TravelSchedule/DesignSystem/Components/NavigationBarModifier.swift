import SwiftUI

/// Навигационная панель из макета: заголовок Bold/17 по центру
/// и стрелка назад слева. Заголовок может отсутствовать —
/// на списке рейсов и фильтрах в макете видна только стрелка.
struct NavigationBarModifier: ViewModifier {
    var title: String?
    let onBack: () -> Void

    func body(content: Content) -> some View {
        content
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: onBack) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(Color.ypBlack)
                    }
                    .accessibilityLabel("Назад")
                }

                if let title {
                    ToolbarItem(placement: .principal) {
                        Text(title)
                            .appFont(.bold17)
                            .foregroundStyle(Color.ypBlack)
                    }
                }
            }
            .toolbarBackground(Color.ypWhite, for: .navigationBar)
    }
}

extension View {
    /// Навигационная панель по макету со своей кнопкой «назад»
    func appNavigationBar(title: String? = nil, onBack: @escaping () -> Void) -> some View {
        modifier(NavigationBarModifier(title: title, onBack: onBack))
    }
}
