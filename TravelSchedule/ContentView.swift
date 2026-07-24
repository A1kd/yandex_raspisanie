import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "tram.fill")
                .font(.largeTitle)
            Text("Расписание Путешествий")
                .font(.headline)
            Text("Результаты вызовов сервисов — в консоли Xcode")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .task {
            await ServicesDemo.runAll()
        }
    }
}

#Preview {
    ContentView()
}
