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
            // Use a tortoise emoji or system icon
            if let tortoiseImage = NSImage(systemSymbolName: "tortoise.fill", accessibilityDescription: "Turtl") {
                button.image = tortoiseImage
                button.image?.isTemplate = true // adapts to light/dark mode
            }
            button.action = #selector(showPopover)
            button.toolTip = "Turtl - Eat your turtles!"
        }
        
        // Set up right-click context menu
        setupContextMenu()
        
        // Prevent the app from showing in the dock
        NSApp.setActivationPolicy(.accessory)
    }
    
    func setupContextMenu() {
        let menu = NSMenu()
        
        // Add task option
        let addTaskItem = NSMenuItem(title: "Add New Task", action: #selector(showPopover), keyEquivalent: "n")
        addTaskItem.target = self
        menu.addItem(addTaskItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // Quit option
        let quitItem = NSMenuItem(title: "Quit Turtl", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        quitItem.target = NSApp
        menu.addItem(quitItem)
        
        statusItem.menu = menu
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
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false // Keep app running even when popover is closed
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        // Clean up when app is quitting
        if let statusItem = statusItem {
            NSStatusBar.system.removeStatusItem(statusItem)
        }
    }
}

