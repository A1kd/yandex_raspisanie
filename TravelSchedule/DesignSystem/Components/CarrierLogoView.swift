import SwiftUI

/// Логотип перевозчика: картинка по ссылке из API, ассет из макета
/// или заглушка, если логотипа нет вовсе. Фон всегда белый, как в макете, —
/// логотипы приходят с прозрачностью и на тёмном фоне пропадают.
struct CarrierLogoView: View {
    let carrier: Carrier

    var body: some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.ypWhiteUniversal)
    }

    @ViewBuilder
    private var content: some View {
        if let url = carrier.logoURL {
            AsyncImage(url: url) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .padding(2)
            } placeholder: {
                placeholder
            }
        } else if let logoName = carrier.logoName {
            Image(logoName)
                .resizable()
                .scaledToFill()
        } else {
            placeholder
        }
    }

    private var placeholder: some View {
        Image(systemName: "tram.fill")
            .resizable()
            .scaledToFit()
            .padding(8)
            .foregroundStyle(Color.ypGray)
    }
}

#Preview {
    HStack(spacing: 16) {
        CarrierLogoView(carrier: MockData.rzd)
            .frame(width: 38, height: 38)
            .clipShape(RoundedRectangle(cornerRadius: 12))

        CarrierLogoView(carrier: MockData.fgk)
            .frame(width: 38, height: 38)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    .padding()
}
