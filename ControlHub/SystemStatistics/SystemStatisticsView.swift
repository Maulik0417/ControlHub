import SwiftUI

struct SystemStatisticsView: View {
    @StateObject private var stats = SystemStatisticsManager()

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            statCard(title: "Free Disk Space", value: stats.freeDiskSpace, icon: "internaldrive")
            statCard(title: "Memory Usage", value: stats.memoryUsage, icon: "memorychip")
            statCard(title: "CPU Load", value: stats.cpuUsage, icon: "cpu")

            Spacer()
        }
        .padding()
        .frame(width: 300)
    }

    private func statCard(title: String, value: String, icon: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24, height: 24)

            VStack(alignment: .leading) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.headline)
                    .foregroundColor(.primary)
            }

            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
    }
}
