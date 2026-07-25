import SwiftUI

/// Синий блок выбора направления с двумя полями и кнопкой обмена
struct DirectionCard: View {
    let from: RoutePoint?
    let to: RoutePoint?
    let onTapField: (DirectionField) -> Void
    let onSwap: () -> Void

    var body: some View {
        HStack(spacing: 16) {
            VStack(spacing: 0) {
                field(.from, point: from)
                field(.to, point: to)
            }
            .background(Color.ypWhiteUniversal)
            .clipShape(RoundedRectangle(cornerRadius: 20))

            Button(action: onSwap) {
                Image("icChange")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color.ypBlue)
                    .frame(width: 36, height: 36)
                    .background(Color.ypWhiteUniversal)
                    .clipShape(Circle())
            }
            .accessibilityLabel("Поменять местами")
        }
        .padding(16)
        .background(Color.ypBlue)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private func field(_ direction: DirectionField, point: RoutePoint?) -> some View {
        Button {
            onTapField(direction)
        } label: {
            Text(point?.title ?? direction.placeholder)
                .appFont(.regular17)
                .foregroundStyle(point == nil ? Color.ypGray : Color.ypBlackUniversal)
                .lineLimit(1)
                .truncationMode(.tail)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 13)
                .frame(height: 48)
                .contentShape(Rectangle())
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        DirectionCard(from: nil, to: nil, onTapField: { _ in }, onSwap: {})
        DirectionCard(
            from: RoutePoint(city: MockData.cities[0], station: MockData.cities[0].stations[1]),
            to: RoutePoint(city: MockData.cities[1], station: MockData.cities[1].stations[0]),
            onTapField: { _ in },
            onSwap: {}
        )
    }
    .padding(16)
    .background(Color.ypWhite)
}
