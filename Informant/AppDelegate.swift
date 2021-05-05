//
//  AppDelegate.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-13.
//

import KeyboardShortcuts
import SwiftUI

@main
class AppDelegate: NSObject, NSApplicationDelegate {
	// This is the actual popover object that is created on app init
	public var window = NSWindow()

	// We use this status bar object to make managing the popover a lot easier
	public var statusBar: StatusBarController?

	// This contians all data needed for the interface
	public var interfaceData = InterfaceData()
	public var contentView = ContentView()

	// Update the popover's view
	public func UpdateInterface(interfaceData: InterfaceData) {
		// Create the SwiftUI view that provides the window contents.
		contentView = ContentView(interfaceData: interfaceData)

		// Set the SwiftUI view to the window view
		window.contentViewController = NSHostingController(rootView: contentView)
	}

	// ------------------ Main Program ⤵︎ ------------------

	func applicationDidFinishLaunching(_: Notification) {

		// TODO: Clean up this section - it asks for accessiblity permissions
		let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
		let accessEnabled = AXIsProcessTrustedWithOptions(options)

		if !accessEnabled {
			print("Access Not Enabled")
		}

		// Update the popover on initialization
		UpdateInterface(interfaceData: interfaceData)

		// TODO: Clean up these window actions
		window = NSWindow(
			contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
			styleMask: [.resizable, .fullSizeContentView],
			backing: .buffered, defer: false)

		window.center()

		window.titleVisibility = .hidden
		window.styleMask.remove(.titled)
		window.isOpaque = false
		window.backgroundColor = .clear
		window.isMovableByWindowBackground = true

		window.contentViewController = NSHostingController(rootView: contentView)
		window.makeKeyAndOrderFront(nil)

		// Initialize status bar
		statusBar = StatusBarController(appDelegate: self)

		// MARK: - Keyboard Shortcuts
		KeyboardShortcuts.onKeyUp(for: .togglePopover) { [self] in

			InterfaceHelper.ToggleInterface(appDelegate: self)
		}
	}

	func applicationWillTerminate(_: Notification) {
		// Insert code here to tear down your application
	}
}
