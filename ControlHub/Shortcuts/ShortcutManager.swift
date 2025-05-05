import Foundation
import AppKit
import Carbon.HIToolbox
import ApplicationServices

class ShortcutManager {
    static let shared = ShortcutManager()
    
    private var eventTap: CFMachPort?

    private init() {
        requestAccessibilityPermission()
        startEventTap()
    }

    private func startEventTap() {
        let mask = (1 << CGEventType.keyDown.rawValue)

        guard let eventTap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: CGEventMask(mask),
            callback: { _, type, event, _ in
                guard type == .keyDown else { return Unmanaged.passUnretained(event) }

                let keyCode = event.getIntegerValueField(.keyboardEventKeycode)
                let flags = event.flags

                let hyperKeyComboActive = flags.contains([.maskCommand, .maskControl, .maskAlternate, .maskSecondaryFn])

                if hyperKeyComboActive {
                    print("🔐 Hyper key + \(keyCode)")

                    switch keyCode {
                    case 18: // 1
                        ShortcutManager.launchApp(bundleIdentifier: "com.apple.Notes")
                    case 19: // 2
                        ShortcutManager.launchApp(bundleIdentifier: "com.apple.Safari")
                    default:
                        break
                    }
                }

                return Unmanaged.passUnretained(event)
            },
            userInfo: nil
        ) else {
            print("❌ Failed to create event tap. Make sure accessibility permissions are granted.")
            return
        }

        self.eventTap = eventTap
        let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        CGEvent.tapEnable(tap: eventTap, enable: true)
    }

    static func launchApp(bundleIdentifier: String) {
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
