import SwiftUI
import WebKit

/// Показывает локальную HTML-страницу. Тему берёт из приложения,
/// поэтому страница остаётся тёмной или светлой вместе с остальными экранами.
struct WebView: UIViewRepresentable {
    let url: URL

    @Environment(\.colorScheme) private var colorScheme

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = .clear
        webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        webView.overrideUserInterfaceStyle = colorScheme == .dark ? .dark : .light
    }
}
