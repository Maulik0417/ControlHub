import Foundation
import IOKit
import IOKit.ps
import SystemConfiguration
import MachO
import mach


class SystemStatistics {
    
    // MARK: - CPU Usage
    func getCPUUsage() -> String {
        var cpuUsage: String = "N/A"
        
        // Fetch CPU statistics via sysctl
        var mib = [CTL_HW, HW_CPU_FREQ]
        var cpuFreq: UInt64 = 0
        var size = MemoryLayout<UInt64>.size
        
        sysctl(&mib, u_int(mib.count), &cpuFreq, &size, nil, 0)
        cpuUsage = "CPU Frequency: \(cpuFreq / 1000) MHz"
        
        return cpuUsage
    }
    
    // MARK: - Memory Usage
    func getMemoryUsage() -> String {
        var info = vm_statistics_data_t()
        var size = HOST_VM_INFO_COUNT
        
        let hostPort = mach_host_self()
        let result = withUnsafeMutablePointer(to: &info) { (ptr) -> kern_return_t in
            return host_statistics(hostPort, HOST_VM_INFO, UnsafeMutableRawPointer(ptr).assumingMemoryBound(to: integer_t.self), &size)
        }
        
        if result == KERN_SUCCESS {
            let usedMemory = info.active_count + info.inactive_count + info.wire_count
            let freeMemory = info.free_count
            return "Used Memory: \(usedMemory), Free Memory: \(freeMemory)"
        }
        
        return "Memory Stats: Error"
    }
    
    // MARK: - GPU Usage (via IOKit)
    func getGPUUsage() -> String {
        // Fetching GPU stats is complex and requires either a third-party library or a custom implementation
        // Using IOKit to get GPU information (limited to basic info)
        let service = IOServiceGetMatchingService(kIOMainPortDefault, IOServiceMatching("IOAccelerator"))
        if service != 0 {
            return "GPU: Available"
        }
        return "GPU: Not available"
    }
    
    // MARK: - Network Stats
    func getNetworkStats() -> String {
        var networkStats = "Network Stats: N/A"
        
        // Fetch network statistics via SystemConfiguration framework
        let interfaces = SCNetworkInterfaceCopyAll()
        
        for interface in interfaces as! [SCNetworkInterface] {
            if let name = SCNetworkInterfaceGetBSDName(interface) {
                networkStats = "Network Interface: \(name)"
                break
            }
        }
        
        return networkStats
    }
    
    // MARK: - Get All System Stats
    func getSystemStats() -> [String: String] {
        let cpu = getCPUUsage()
        let memory = getMemoryUsage()
        let gpu = getGPUUsage()
        let network = getNetworkStats()
        
        return [
            "CPU": cpu,
            "Memory": memory,
            "GPU": gpu,
            "Network": network
        ]
    }
}
