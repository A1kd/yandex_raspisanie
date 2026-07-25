import SwiftUI

/// Экран «Уточнить время»: интервалы отправления и показ рейсов с пересадками.
/// Изменения применяются к списку по кнопке «Применить».
struct FiltersView: View {
    @Binding var filter: RouteFilter
    @Environment(\.dismiss) private var dismiss

    @State private var draft: RouteFilter

    init(filter: Binding<RouteFilter>) {
        _filter = filter
        _draft = State(initialValue: filter.wrappedValue)
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    section(title: "Время отправления") {
                        ForEach(DepartureInterval.allCases) { interval in
                            Button {
                                toggle(interval)
                            } label: {
                                ListRow(title: interval.title) {
                                    CheckboxIcon(isOn: draft.intervals.contains(interval))
                                }
                            }
                        }
                    }

                    section(title: "Показывать варианты с пересадками") {
                        transferRow(title: "Да", value: true)
                        transferRow(title: "Нет", value: false)
                    }
                }
                .padding(.top, 16)
            }
            .scrollIndicators(.hidden)

            if !draft.isEmpty {
                PrimaryButton(title: "Применить") {
                    filter = draft
                    dismiss()
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.ypWhite)
        .appNavigationBar { dismiss() }
    }

    private func section<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .appFont(.bold24)
                .foregroundStyle(Color.ypBlack)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)

            VStack(spacing: 0) {
                content()
            }
        }
    }

    private func transferRow(title: String, value: Bool) -> some View {
        Button {
            draft.showsTransfers = value
        } label: {
            ListRow(title: title) {
                RadioButtonIcon(isOn: draft.showsTransfers == value)
            }
        }
    }

    private func toggle(_ interval: DepartureInterval) {
        if draft.intervals.contains(interval) {
            draft.intervals.remove(interval)
        } else {
            draft.intervals.insert(interval)
        }
    }
}

#Preview {
    NavigationStack {
        FiltersView(filter: .constant(RouteFilter()))
    }
}
