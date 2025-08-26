//
//  AppDelegate.swift
//  Turtl
//
//  Created by Charvi Bansal on 7/31/25.
//

import Cocoa
import SwiftUI

var popover = NSPopover()

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var window: NSWindow?

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Create menu bar item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

        if let button = statusItem.button {
            // Use a tortoise emoji or system icon
            if let tortoiseImage = NSImage(systemSymbolName: "tortoise.fill", accessibilityDescription: "Turtl") {
                button.image = tortoiseImage
                button.image?.isTemplate = true // adapts to light/dark mode
            }

            // Set up the button behavior
            button.action = #selector(togglePopover)
            button.target = self
            button.toolTip = "Turtl - Click to open task manager"

            // Remove the menu from button to prevent interference
            button.menu = nil

            // Add right-click gesture recognition for quit option
            let rightClickGesture = NSClickGestureRecognizer(target: self, action: #selector(handleRightClick))
            rightClickGesture.buttonMask = 2 // Right mouse button
            button.addGestureRecognizer(rightClickGesture)
        }

        // Show the popover when app launches (from dock click)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.togglePopover()
        }
    }

    @objc private func handleRightClick() {
        // Show context menu on right-click
        let contextMenu = createContextMenu()
        if let button = statusItem.button {
            contextMenu.popUp(positioning: nil, at: NSPoint(x: 0, y: button.bounds.height), in: button)
        }
    }

    private func createContextMenu() -> NSMenu {
        let menu = NSMenu()

        // Add quit option only
        let quitItem = NSMenuItem(title: "Quit Turtl", action: #selector(quitApp), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)

        return menu
    }

    @objc private func quitApp() {
        NSApplication.shared.terminate(nil)
    }

    @objc func togglePopover() {
        if popover.isShown {
            popover.performClose(nil)
        } else {
            let popoverView = NSHostingController(rootView: TurtlPopoverView())
            popover.contentSize = NSSize(width: 320, height: 400)
            popover.contentViewController = popoverView
            popover.behavior = .transient
            popover.animates = true

            if let button = statusItem.button {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            }
        }
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false // Keep app running even when popover is closed
    }

    func applicationWillTerminate(_ notification: Notification) {
        // Clean up when app is quitting
        cleanup()
    }

    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        // Ensure clean termination
        cleanup()
        return .terminateNow
    }

    private func cleanup() {
        // Remove status item from menu bar
        if let statusItem = statusItem {
            NSStatusBar.system.removeStatusItem(statusItem)
            self.statusItem = nil
        }
        // Close popover if open
        if popover.isShown {
            popover.performClose(nil)
        }
    }

    // Handle dock icon clicks
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        // When dock icon is clicked, show the popover
        togglePopover()
        return true
    }
}
