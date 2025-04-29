import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var popover: NSPopover!
    var popoverTransiencyMonitor: Any?

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Create the popover with SwiftUI content
        popover = NSPopover()
        popover.contentSize = NSSize(width: 280, height: 360)
        popover.behavior = .transient
//        popover.contentViewController = NSHostingController(rootView: contentView)
        popover.contentViewController = NSHostingController(rootView: ClipboardView())

        // Create status bar item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "square.grid.2x2", accessibilityDescription: "DevDesk")
            button.action = #selector(togglePopover(_:))
            button.target = self
        }
    }

    @objc func togglePopover(_ sender: AnyObject?) {
        if let button = statusItem.button {
            if popover.isShown {
                popover.performClose(sender)
            } else {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)

                // Optional: dismiss on click outside
                popoverTransiencyMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown]) { [weak self] _ in
                    self?.popover.performClose(sender)
                    if let monitor = self?.popoverTransiencyMonitor {
                        NSEvent.removeMonitor(monitor)
                        self?.popoverTransiencyMonitor = nil
                    }
                }
            }
        }
    }
}
