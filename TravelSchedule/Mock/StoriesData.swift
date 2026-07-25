import Foundation

/// Истории из макета: девять картинок с текстами-заглушками.
/// Тексты в Figma заданы плейсхолдерами, поэтому повторяют макет один в один.
enum StoriesData {
    static let all: [Story] = (1...9).map { index in
        Story(
            id: index,
            imageName: "story\(index)",
            previewText: previewText,
            title: title,
            text: text
        )
    }

    private static let previewText = "Text Text Text Text Text Text Text Text Text"

    private static let title = "Text Text Text Text Text Text Text Text Text Text"

    private static let text = """
    Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text \
    Text Text Text Text Text Text Text Text
    """
}
