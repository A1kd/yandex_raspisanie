import SwiftUI

/// Пользовательское соглашение. Показывается поверх таббара
/// и открывает свёрстанный офертой HTML из бандла.
struct AgreementView: View {
    @StateObject private var viewModel = AgreementViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Group {
                if let offerURL = viewModel.offerURL {
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
