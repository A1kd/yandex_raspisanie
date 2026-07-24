import SwiftUI

/// Поле поиска из макета: высота 36, скругление 10,
/// лупа и плейсхолдер серые, крестик появляется при непустом тексте.
struct SearchField: View {
    @Binding var text: String
    var placeholder: String = "Введите запрос"

    var body: some View {
        HStack(spacing: 0) {
            Image(systemName: "magnifyingglass")
                .appFont(.regular17)
                .foregroundStyle(Color.ypGray)
                .frame(width: 25, alignment: .leading)

            TextField("", text: $text, prompt: Text(placeholder).foregroundColor(.ypGray))
                .appFont(.regular17)
                .foregroundStyle(Color.ypBlack)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)

            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .appFont(.regular17)
                        .foregroundStyle(Color.ypGray)
                }
                .accessibilityLabel("Очистить поле поиска")
            }
        }
        .padding(.horizontal, 8)
        .frame(height: 36)
        .background(Color.ypSearchField)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
    }
}

#Preview {
    VStack {
        SearchField(text: .constant(""))
        SearchField(text: .constant("Москва"))
    }
    .background(Color.ypWhite)
}
