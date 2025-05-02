import Foundation
import SwiftUI

class SystemStatisticsManager: ObservableObject {
    @Published var freeDiskSpace: String = "Loading..."
    @Published var memoryUsage: String = "Loading..."
    @Published var cpuUsage: String = "Loading..."

    private var timer: Timer?
    private var previousCPUTicks: host_cpu_load_info?

    init() {
        updateStats()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateStats()
        }
    }

    private func updateStats() {
        freeDiskSpace = getFreeDiskSpace()
        memoryUsage = getMemoryUsage()
        cpuUsage = getCPULoad()
    }

    private func getFreeDiskSpace() -> String {
        let url = URL(fileURLWithPath: "/")
        do {
            let values = try url.resourceValues(forKeys: [
                .volumeAvailableCapacityForImportantUsageKey,
                .volumeAvailableCapacityKey
            ])
            
            let capacity: Int64? = values.volumeAvailableCapacityForImportantUsage ??
                                   (values.volumeAvailableCapacity != nil ? Int64(values.volumeAvailableCapacity!) : nil)

            if let bytes = capacity {
                let gb = Double(bytes) / 1_073_741_824
                return String(format: "%.2f GB", gb)
            }
        } catch {
            return "N/A"
        }
        return "N/A"
    }

    private func getMemoryUsage() -> String {
            var vmStat = vm_statistics64()
            var count = mach_msg_type_number_t(MemoryLayout.size(ofValue: vmStat) / MemoryLayout<integer_t>.size)

            let result = withUnsafeMutablePointer(to: &vmStat) {
                $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                    host_statistics64(mach_host_self(), HOST_VM_INFO64, $0, &count)
                }
            }

            guard result == KERN_SUCCESS else { return "N/A" }

            let used = UInt64(vmStat.active_count + vmStat.inactive_count + vmStat.wire_count) * UInt64(vm_page_size)
            let total = ProcessInfo.processInfo.physicalMemory
            let percent = Double(used) / Double(total) * 100

            return String(format: "%.1f%%", percent)
        }

    private func getCPULoad() -> String {
        var load = host_cpu_load_info()
        var count = mach_msg_type_number_t(MemoryLayout<host_cpu_load_info_data_t>.stride / MemoryLayout<integer_t>.stride)

        let result = withUnsafeMutablePointer(to: &load) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                host_statistics(mach_host_self(), HOST_CPU_LOAD_INFO, $0, &count)
            }
        }

        guard result == KERN_SUCCESS else { return "N/A" }

        if let previous = previousCPUTicks {
            let userDiff = Double(load.cpu_ticks.0 - previous.cpu_ticks.0)
            let systemDiff = Double(load.cpu_ticks.1 - previous.cpu_ticks.1)
            let idleDiff = Double(load.cpu_ticks.2 - previous.cpu_ticks.2)
            let niceDiff = Double(load.cpu_ticks.3 - previous.cpu_ticks.3)
            let total = userDiff + systemDiff + idleDiff + niceDiff
            let usage = ((userDiff + systemDiff + niceDiff) / total) * 100.0

            previousCPUTicks = load
            return String(format: "%.1f%%", usage)
        }

        previousCPUTicks = load
        return "Calculating..."
    }
}
