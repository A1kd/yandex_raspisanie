import SwiftUI

/// Карточка рейса из макета: 104 в высоту, скругление 24, фон светло-серый
/// в обеих темах, поэтому текст на ней — универсальный чёрный.
struct RouteCard: View {
    let segment: RouteSegment

    var body: some View {
        VStack(spacing: 4) {
            HStack(alignment: .top, spacing: 8) {
                CarrierLogoView(carrier: segment.carrier)
                    .frame(width: 38, height: 38)
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                VStack(alignment: .leading, spacing: 2) {
                    Text(segment.carrier.title)
                        .appFont(.regular17)
                        .foregroundStyle(Color.ypBlackUniversal)

                    if let transferText = segment.transferText {
                        Text(transferText)
                            .appFont(.regular12)
                            .foregroundStyle(Color.ypRed)
                    }
                }

                Spacer(minLength: 4)

                Text(segment.dateText)
                    .appFont(.regular12)
                    .foregroundStyle(Color.ypBlackUniversal)
            }
            .padding(.horizontal, 14)

            HStack(spacing: 5) {
                Text(segment.departureText)
                    .appFont(.regular17)
                    .foregroundStyle(Color.ypBlackUniversal)

                line

                Text(segment.durationText)
                    .appFont(.regular12)
                    .foregroundStyle(Color.ypBlackUniversal)
                    .fixedSize()

                line

                Text(segment.arrivalText)
                    .appFont(.regular17)
                    .foregroundStyle(Color.ypBlackUniversal)
            }
            .padding(14)
        }
        .padding(.top, 14)
        .frame(maxWidth: .infinity)
        .background(Color.ypLightGray)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }

    private var line: some View {
        Rectangle()
            .fill(Color.ypGray)
            .frame(height: 1)
    }
}

#Preview {
    VStack(spacing: 8) {
        ForEach(MockData.segments.prefix(3)) { segment in
            RouteCard(segment: segment)
        }
    }
    .padding(16)
    .background(Color.ypWhite)
}
