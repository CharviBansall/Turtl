//
//  TurtlApp.swift
//  Turtl
//
//  Created by Charvi Bansal on 7/31/25.
//

import SwiftUI

@main
struct TurtlApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            EmptyView()
        }
        .commands {
            // Remove default menu items
            CommandGroup(replacing: .newItem) { }
            CommandGroup(replacing: .appInfo) { }
            CommandGroup(replacing: .systemServices) { }
        }
    }
}

