import SwiftUI

/// Индикаторы над историями: по сегменту на историю.
/// Пройденные закрашены целиком, текущий заполняется по мере просмотра.
struct StoriesProgressBar: View {
    let count: Int
    let currentIndex: Int
    let progress: CGFloat

    private let spacing: CGFloat = 6
    private let height: CGFloat = 6

    var body: some View {
        GeometryReader { geometry in
            let segmentWidth = self.segmentWidth(totalWidth: geometry.size.width)

            HStack(spacing: spacing) {
                ForEach(0..<count, id: \.self) { index in
                    segment(width: segmentWidth, fill: fill(for: index))
                }
            }
        }
        .frame(height: height)
    }

    private func segment(width: CGFloat, fill: CGFloat) -> some View {
        ZStack(alignment: .leading) {
            Capsule()
                .fill(Color.ypWhiteUniversal)

            Capsule()
                .fill(Color.ypBlue)
                .frame(width: width * fill)
        }
        .frame(width: width, height: height)
    }

    private func segmentWidth(totalWidth: CGFloat) -> CGFloat {
        guard count > 0 else { return 0 }
        let spacings = spacing * CGFloat(count - 1)
        return max((totalWidth - spacings) / CGFloat(count), 0)
    }

    /// 0 — история ещё не показывалась, 1 — уже просмотрена целиком
    private func fill(for index: Int) -> CGFloat {
        if index < currentIndex { return 1 }
        if index > currentIndex { return 0 }
        return min(max(progress, 0), 1)
    }
}

#Preview {
    StoriesProgressBar(count: 9, currentIndex: 3, progress: 0.4)
        .padding(12)
        .background(Color.ypBlackUniversal)
}
