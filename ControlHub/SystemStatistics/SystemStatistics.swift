import Foundation
import Combine

struct SystemStats {
    var freeDiskSpaceGB: Double
    var usedMemoryMB: Double
    var totalMemoryMB: Double
    var cpuLoad: Double
}

class SystemStatsManager: ObservableObject {
    @Published var stats: SystemStats = SystemStats(freeDiskSpaceGB: 0, usedMemoryMB: 0, totalMemoryMB: 0, cpuLoad: 0)

    private var timer: Timer?

    init() {
        updateStats()
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            self.updateStats()
        }
    }

    private func updateStats() {
        stats = SystemStats(
            freeDiskSpaceGB: getFreeDiskSpaceInGB(),
            usedMemoryMB: getUsedMemoryInMB(),
            totalMemoryMB: getTotalMemoryInMB(),
            cpuLoad: getCPULoad()
        )
    }

    private func getFreeDiskSpaceInGB() -> Double {
        if let attrs = try? FileManager.default.attributesOfFileSystem(forPath: "/"),
           let freeSize = attrs[.systemFreeSize] as? NSNumber {
            return Double(truncating: freeSize) / 1_000_000_000
        }
        return 0
    }

    private func getTotalMemoryInMB() -> Double {
        Double(ProcessInfo.processInfo.physicalMemory) / 1_000_000
    }

    private func getUsedMemoryInMB() -> Double {
        var vmStats = vm_statistics64()
        var size = UInt32(MemoryLayout<vm_statistics64_data_t>.stride / MemoryLayout<integer_t>.stride)

        let hostPort: mach_port_t = mach_host_self()
        let HOST_VM_INFO64_COUNT = mach_msg_type_number_t(size)
        let result = withUnsafeMutablePointer(to: &vmStats) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(size)) {
                host_statistics64(hostPort, HOST_VM_INFO64, $0, &size)
            }
        }

        guard result == KERN_SUCCESS else { return 0 }

        let pageSize = Double(vm_kernel_page_size)
        let used = Double(vmStats.active_count + vmStats.inactive_count + vmStats.wire_count) * pageSize
        return used / 1_000_000
    }

    private func getCPULoad() -> Double {
        var threadsList: thread_act_array_t?
        var threadCount: mach_msg_type_number_t = 0
        var threadInfoCount: mach_msg_type_number_t

        let result = task_threads(mach_task_self_, &threadsList, &threadCount)
        guard result == KERN_SUCCESS, let threads = threadsList else { return 0 }

        var totalCPU: Double = 0
        for i in 0..<threadCount {
            var threadInfoData = thread_basic_info()
            threadInfoCount = mach_msg_type_number_t(THREAD_INFO_MAX)

            let kr = withUnsafeMutablePointer(to: &threadInfoData) {
                $0.withMemoryRebound(to: integer_t.self, capacity: Int(threadInfoCount)) {
                    thread_info(threads[Int(i)], thread_flavor_t(THREAD_BASIC_INFO), $0, &threadInfoCount)
                }
            }

            guard kr == KERN_SUCCESS else { continue }

            let threadBasicInfo = threadInfoData
            if (threadBasicInfo.flags & TH_FLAGS_IDLE) == 0 {
                totalCPU += Double(threadBasicInfo.cpu_usage) / Double(TH_USAGE_SCALE) * 100.0
            }
        }

        return totalCPU
    }
}
