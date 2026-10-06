import SwiftUI

/// Экран «Уточнить время»: интервалы отправления и показ рейсов с пересадками.
/// Изменения применяются к списку по кнопке «Применить».
struct FiltersView: View {
    @Binding var filter: RouteFilter
    @Environment(\.dismiss) private var dismiss

    @StateObject private var viewModel: FiltersViewModel

    init(filter: Binding<RouteFilter>) {
        _filter = filter
        _viewModel = StateObject(wrappedValue: FiltersViewModel(filter: filter.wrappedValue))
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    section(title: "Время отправления") {
                        ForEach(DepartureInterval.allCases) { interval in
                            Button {
                                viewModel.toggle(interval)
                            } label: {
                                ListRow(title: interval.title) {
                                    CheckboxIcon(isOn: viewModel.draft.intervals.contains(interval))
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

            if viewModel.canApply {
                PrimaryButton(title: "Применить") {
                    filter = viewModel.draft
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
            viewModel.selectTransfers(value)
        } label: {
            ListRow(title: title) {
                RadioButtonIcon(isOn: viewModel.draft.showsTransfers == value)
            }
        }
    }
}

#Preview {
    NavigationStack {
        FiltersView(filter: .constant(RouteFilter()))
    }
}
