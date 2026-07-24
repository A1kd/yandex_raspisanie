import SwiftUI

/// Заглушка карточки перевозчика — экран верстается в следующем спринте
struct CarrierCardView: View {
    let carrier: Carrier

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 8) {
            Text("Карточка перевозчика")
                .appFont(.bold24)
                .foregroundStyle(Color.ypBlack)

            Text(carrier.fullTitle)
                .appFont(.regular17)
                .foregroundStyle(Color.ypGray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.ypWhite)
        .appNavigationBar(title: "Информация о перевозчике") { dismiss() }
    }
}

#Preview {
    NavigationStack {
        CarrierCardView(carrier: MockData.rzd)
    }
}
