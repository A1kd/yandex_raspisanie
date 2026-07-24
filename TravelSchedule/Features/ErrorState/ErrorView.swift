import SwiftUI

/// Экраны «Ошибка сервера» и «Нет интернета»:
/// иллюстрация 223×223 со скруглением 70 и подпись Bold/24 под ней.
struct ErrorView: View {
    let error: AppError

    var body: some View {
        VStack(spacing: 16) {
            Image(error.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 223, height: 223)
                .clipShape(RoundedRectangle(cornerRadius: 70))

            Text(error.title)
                .appFont(.bold24)
                .foregroundStyle(Color.ypBlack)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.ypWhite)
    }
}

#Preview("Ошибка сервера") {
    ErrorView(error: .serverError)
}

#Preview("Нет интернета") {
    ErrorView(error: .noInternet)
}
