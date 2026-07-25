import SwiftUI

/// Одна история на весь экран: картинка во всю площадь,
/// заголовок Bold/34 и описание Regular/20 внизу.
struct StoryPageView: View {
    let story: Story

    var body: some View {
        GeometryReader { geometry in
            Image(story.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: geometry.size.width, height: geometry.size.height)
                .clipped()
                .overlay(alignment: .bottomLeading) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text(story.title)
                            .appFont(.bold34)
                            .lineLimit(3)

                        Text(story.text)
                            .appFont(.regular20)
                            .lineLimit(3)
                    }
                    .foregroundStyle(Color.ypWhiteUniversal)
                    .frame(width: geometry.size.width - 32, alignment: .leading)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 40)
                }
        }
    }
}

#Preview {
    StoryPageView(story: StoriesData.all[0])
}
