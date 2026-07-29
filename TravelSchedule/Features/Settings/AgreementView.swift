import SwiftUI

/// Пользовательское соглашение. Показывается поверх таббара
/// и открывает свёрстанный офертой HTML из бандла.
struct AgreementView: View {
    @Environment(\.dismiss) private var dismiss

    private let offerURL = Bundle.main.url(forResource: "offer", withExtension: "html")

    var body: some View {
        NavigationStack {
            Group {
                if let offerURL {
                    WebView(url: offerURL)
                } else {
                    EmptyStateView(text: "Соглашение недоступно")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.ypWhite)
            .appNavigationBar(title: "Пользовательское соглашение") { dismiss() }
        }
    }
}

#Preview {
    AgreementView()
}
