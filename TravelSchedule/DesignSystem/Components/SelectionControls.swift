import SwiftUI

/// Чекбокс из макета: квадрат 20×20 со скруглением 4.
/// Выключенный — обводка 2, включённый — заливка с белой галочкой.
struct CheckboxIcon: View {
    let isOn: Bool

    var body: some View {
        ZStack {
            if isOn {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.ypBlack)
                Image(systemName: "checkmark")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(Color.ypWhite)
            } else {
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.ypBlack, lineWidth: 2)
            }
        }
        .frame(width: 20, height: 20)
    }
}

/// Радиокнопка из макета: круг 20×20 с обводкой 2 и точкой 10×10 внутри
struct RadioButtonIcon: View {
    let isOn: Bool

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.ypBlack, lineWidth: 2)
            if isOn {
                Circle()
                    .fill(Color.ypBlack)
                    .frame(width: 10, height: 10)
            }
        }
        .frame(width: 20, height: 20)
    }
}

#Preview {
    HStack(spacing: 24) {
        CheckboxIcon(isOn: true)
        CheckboxIcon(isOn: false)
        RadioButtonIcon(isOn: true)
        RadioButtonIcon(isOn: false)
    }
    .padding()
    .background(Color.ypWhite)
}
