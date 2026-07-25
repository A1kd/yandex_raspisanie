import SwiftUI

/// Карточка перевозчика: логотип, название и контакты.
/// По тапу на контакт открывается почта или звонилка.
struct CarrierCardView: View {
    let carrier: Carrier

    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                logo
                    .frame(height: 104)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .padding(.horizontal, 16)

                Text(carrier.fullTitle)
                    .appFont(.bold24)
                    .foregroundStyle(Color.ypBlack)
                    .padding(.horizontal, 16)

                VStack(spacing: 0) {
                    ValueRow(title: "E-mail", value: carrier.email) {
                        open("mailto:\(carrier.email)")
                    }

                    ValueRow(title: "Телефон", value: carrier.phone) {
                        open("tel:\(phoneDigits)")
                    }
                }
            }
            .padding(.top, 16)
        }
        .scrollIndicators(.hidden)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.ypWhite)
        .appNavigationBar(title: "Информация о перевозчике") { dismiss() }
    }

    /// Широкий логотип занимает всю ширину карточки, а значок из списка рейсов
    /// вписывается по высоте — иначе от квадратной картинки останется середина
    @ViewBuilder
    private var logo: some View {
        if let bannerName = carrier.bannerName {
            Image(bannerName)
                .resizable()
                .scaledToFill()
        } else {
            Image(carrier.logoName)
                .resizable()
                .scaledToFit()
        }
    }

    /// Номер без скобок и дефисов — в таком виде его принимает звонилка
    private var phoneDigits: String {
        carrier.phone.filter { $0.isNumber || $0 == "+" }
    }

    private func open(_ string: String) {
        guard let url = URL(string: string) else { return }
        openURL(url)
    }
}

#Preview {
    NavigationStack {
        CarrierCardView(carrier: MockData.rzd)
    }
}
