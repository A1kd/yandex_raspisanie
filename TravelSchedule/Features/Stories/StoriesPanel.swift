import SwiftUI

/// Горизонтальная коллекция историй в верхней части главного экрана.
/// Вместе с карточкой наверх отдаётся её позиция на экране —
/// из неё разворачивается полноэкранный просмотр.
struct StoriesPanel: View {
    let stories: [Story]
    let seenStoryIDs: Set<Int>
    let onSelect: (Int, CGRect) -> Void

    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 12) {
                ForEach(Array(stories.enumerated()), id: \.element.id) { index, story in
                    GeometryReader { geometry in
                        StoryPreviewCard(story: story, isSeen: seenStoryIDs.contains(story.id))
                            .onTapGesture {
                                onSelect(index, geometry.frame(in: .global))
                            }
                    }
                    .frame(width: StoryPreviewCard.size.width, height: StoryPreviewCard.size.height)
                }
            }
            .padding(.horizontal, 16)
        }
        .scrollIndicators(.hidden)
        .padding(.vertical, 24)
    }
}

#Preview {
    StoriesPanel(stories: StoriesData.all, seenStoryIDs: [1, 2]) { _, _ in }
        .background(Color.ypWhite)
}
