import SwiftUI

struct SystemStatisticsView: View {
    @StateObject private var stats = SystemStatisticsManager()

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            statCard(
                title: "Free Disk Space",
                value: stats.freeDiskSpace,
                icon: "internaldrive",
                color: diskSpaceColor(from: stats.freeDiskSpace)
            )

            statCard(
                title: "Memory Usage",
                value: stats.memoryUsage,
                icon: "memorychip",
                color: memoryUsageColor(from: stats.memoryUsage)
            )

            statCard(
                title: "CPU Load",
                value: stats.cpuUsage,
                icon: "cpu",
                color: cpuLoadColor(from: stats.cpuUsage)
            )

            Spacer()

            Text("*Accurate within 5%")
                .font(.footnote)
                .foregroundColor(.secondary)
                .padding(.top, 8)
        }
        .padding()
        .frame(width: 300)
    }

    private func statCard(title: String, value: String, icon: String, color: Color) -> some View {
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
                    .foregroundColor(color)
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

    // MARK: - Color logic helpers

    private func diskSpaceColor(from value: String) -> Color {
        guard let free = Double(value.replacingOccurrences(of: " GB", with: "")),
              let total = getTotalDiskSpaceInGB() else { return .primary }

        let percent = (free / total) * 100
        switch percent {
        case ..<33: return .red
        case 33..<66: return .yellow
        default: return .green
        }
    }

    private func memoryUsageColor(from value: String) -> Color {
        guard let percent = Double(value.replacingOccurrences(of: "%", with: "")) else { return .primary }

        switch percent {
        case ..<61: return .green
        case 61..<85: return .yellow
        default: return .red
        }
    }

    private func cpuLoadColor(from value: String) -> Color {
        guard let percent = Double(value.replacingOccurrences(of: "%", with: "")) else { return .primary }

        switch percent {
        case ..<51: return .green
        case 51..<85: return .yellow
        default: return .red
        }
    }

    private func getTotalDiskSpaceInGB() -> Double? {
        do {
            let attrs = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())
            if let total = attrs[.systemSize] as? NSNumber {
                return Double(truncating: total) / 1_073_741_824
            }
        } catch {
            return nil
        }
        return nil
    }
}
