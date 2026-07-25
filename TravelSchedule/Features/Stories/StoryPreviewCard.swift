import SwiftUI

/// Карточка истории в панели на главном экране: 92×140 со скруглением 16.
/// Непросмотренная — с синей обводкой и яркой картинкой,
/// просмотренная — приглушённая и без обводки.
struct StoryPreviewCard: View {
    let story: Story
    let isSeen: Bool

    static let size = CGSize(width: 92, height: 140)

    private var borderWidth: CGFloat { isSeen ? 0 : 4 }

    var body: some View {
        Image(story.imageName)
            .resizable()
            .scaledToFill()
            .frame(width: Self.size.width, height: Self.size.height)
            .overlay(alignment: .bottomLeading) {
                Text(story.previewText)
                    .appFont(.regular12)
                    .foregroundStyle(Color.ypWhiteUniversal)
                    .lineLimit(3)
                    .padding(.horizontal, 8)
                    .padding(.bottom, 12)
            }
            .opacity(isSeen ? 0.5 : 1)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(Color.ypBlue, lineWidth: borderWidth)
            }
            .accessibilityElement(children: .combine)
            .accessibilityAddTraits(.isButton)
            .accessibilityIdentifier("story-\(story.id)")
    }
}

#Preview {
    HStack(spacing: 12) {
        StoryPreviewCard(story: StoriesData.all[0], isSeen: false)
        StoryPreviewCard(story: StoriesData.all[1], isSeen: true)
    }
    .padding()
    .background(Color.ypWhite)
}
