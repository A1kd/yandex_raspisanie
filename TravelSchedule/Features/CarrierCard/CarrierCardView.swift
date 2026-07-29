import SwiftUI

/// Карточка перевозчика: логотип, название и контакты.
/// По тапу на контакт открывается почта или звонилка.
struct CarrierCardView: View {
    @StateObject private var viewModel: CarrierCardViewModel

    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL

    init(carrier: Carrier) {
        _viewModel = StateObject(wrappedValue: CarrierCardViewModel(carrier: carrier))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                logo
                    .frame(height: 104)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .padding(.horizontal, 16)

                Text(viewModel.carrier.fullTitle)
                    .appFont(.bold24)
                    .foregroundStyle(Color.ypBlack)
                    .padding(.horizontal, 16)

                VStack(spacing: 0) {
                    if viewModel.hasEmail {
                        ValueRow(title: "E-mail", value: viewModel.carrier.email) {
                            open(viewModel.emailURL)
                        }
                    }

                    if viewModel.hasPhone {
                        ValueRow(title: "Телефон", value: viewModel.carrier.phone) {
                            open(viewModel.phoneURL)
                        }
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

    /// Широкий логотип из макета занимает всю ширину карточки, а логотип
    /// из API и значок из списка рейсов вписываются по высоте
    @ViewBuilder
    private var logo: some View {
        if let bannerName = viewModel.carrier.bannerName {
            Image(bannerName)
                .resizable()
                .scaledToFill()
        } else {
            CarrierLogoView(carrier: viewModel.carrier)
        }
    }

    private func open(_ url: URL?) {
        guard let url else { return }
        openURL(url)
    }
}

#Preview {
    NavigationStack {
        CarrierCardView(carrier: MockData.rzd)
    }
}
