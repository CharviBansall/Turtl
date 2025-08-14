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

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Create menu bar item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        
        if let button = statusItem.button {
            // Use a frog emoji or system icon
            if let frogImage = NSImage(systemSymbolName: "tortoise.fill", accessibilityDescription: "FrogTime") {
                button.image = frogImage
                button.image?.isTemplate = true // adapts to light/dark mode
            }
            button.action = #selector(showPopover)
            button.toolTip = "Turtl - Eat your frogs!"
        }
    }

    @objc func showPopover() {
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
}

