import SwiftUI

struct SystemStatisticsView: View {
    @StateObject private var statsManager = SystemStatsManager()

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("📊 System Statistics")
                .font(.title2)
                .bold()

            StatCard(title: "💾 Free Disk Space", value: String(format: "%.2f GB", statsManager.stats.freeDiskSpaceGB), color: .blue)

            StatCard(title: "🧠 Used Memory", value: String(format: "%.2f MB", statsManager.stats.usedMemoryMB), color: .orange)

            StatCard(title: "📦 Total Memory", value: String(format: "%.2f MB", statsManager.stats.totalMemoryMB), color: .purple)

            StatCard(title: "🔥 CPU Load", value: String(format: "%.1f%%", statsManager.stats.cpuLoad), color: .red)

            Spacer()
        }
        .padding()
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let color: Color

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)

                Text(value)
                    .font(.system(size: 20, weight: .bold, design: .monospaced))
                    .foregroundColor(color)
            }

            Spacer()
        }
        .padding()
        .background(Color(NSColor.windowBackgroundColor))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
