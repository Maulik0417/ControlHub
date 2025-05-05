import Foundation
import AppKit
import Carbon.HIToolbox

class ShortcutManager {
    static let shared = ShortcutManager()
    
    private var monitor: Any?
    private var hyperKeyIsActive = false

    private init() {
        requestAccessibilityPermission()
        startMonitoring()
    }

    func startMonitoring() {
        monitor = NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { [weak self] event in
            self?.handle(event)
        }
    }

    func stopMonitoring() {
        if let monitor = monitor {
            NSEvent.removeMonitor(monitor)
        }
    }

    private func handle(_ event: NSEvent) {
        let flags = event.modifierFlags.intersection(.deviceIndependentFlagsMask)

        // fn is not part of modifierFlags; use a workaround
        let fnIsPressed = CGEvent(source: nil)?.flags.contains(.maskSecondaryFn) ?? false

        let hyperKeyComboActive = flags.contains([.control, .option, .command]) && fnIsPressed

        if hyperKeyComboActive {
            hyperKeyIsActive = true
        }

        if hyperKeyIsActive {
            switch event.keyCode {
            case 18: // key "1"
                openApp(bundleIdentifier: "com.apple.Notes") // Example
            case 19: // key "2"
                openApp(bundleIdentifier: "com.apple.Safari")
            default:
                break
            }
        }

        // Reset state if key is released (optional)
        if event.type == .keyUp {
            hyperKeyIsActive = false
        }
    }

    private func openApp(bundleIdentifier: String) {
        guard let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: bundleIdentifier) else {
            print("❌ Could not find app with bundle identifier: \(bundleIdentifier)")
            return
        }

        let config = NSWorkspace.OpenConfiguration()
        NSWorkspace.shared.openApplication(at: url, configuration: config, completionHandler: nil)
    }

    private func requestAccessibilityPermission() {
        let options: [String: Any] = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
        let trusted = AXIsProcessTrustedWithOptions(options as CFDictionary)
        if !trusted {
            print("⚠️ Accessibility permissions required")
        }
    }
}
