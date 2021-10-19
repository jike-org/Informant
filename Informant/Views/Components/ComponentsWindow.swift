//
//  ComponentsWindow.swift
//  Informant
//
//  Created by Ty Irvine on 2021-07-17.
//

import SwiftUI

// MARK: - Universal Window Components

/// Small web-like link.
struct ComponentsSmallLink: View {

	let label: String

	@Binding var hovering: Bool

	let action: () -> Void

	var body: some View {
		Text(label)
			.underline(hovering == true ? true : false, color: .primary.opacity(0.5))
			.SettingsVersionFont()
			.opacity(hovering == true ? 0.75 : 1.0)
			.onTapGesture {
				action()
			}
			.whenHovered { hovering in
				self.hovering = hovering
			}
	}
}

/// Just an image of the app icon
struct ComponentsWindowAppIcon: View {
	var body: some View {
		Image(nsImage: NSImage(named: ContentManager.Images.appIcon) ?? NSImage())
			.resizable()
			.frame(width: Style.Icons.appIconSize, height: Style.Icons.appIconSize, alignment: .center)
	}
}

/// This is just a toggle with some padding between the toggle and title.
struct TogglePadded: View {

	let title: String
	var binding: Binding<Bool>

	internal init(_ title: String, isOn: Binding<Bool>) {
		self.title = title
		self.binding = isOn
	}

	var body: some View {
		Toggle(isOn: binding) {
			Text(title).togglePadding()
		}
	}
}

extension Text {

	/// Adds some extra padding at the end
	func togglePadding() -> some View {
		self.padding([.leading], 4)
	}
}

// MARK: - Settings Window Components

struct ComponentsSettingsToggleSection<ContentFirst: View, ContentSecond: View, ContentThird: View>: View {

	let firstColumn: ContentFirst
	let secondColumn: ContentSecond
	let thirdColumn: ContentThird
	let label: String

	internal init(
		_ label: String,
		@ViewBuilder firstColumn: @escaping () -> ContentFirst,
		@ViewBuilder secondColumn: @escaping () -> ContentSecond,
		@ViewBuilder thirdColumn: @escaping () -> ContentThird
	) {
		self.firstColumn = firstColumn()
		self.secondColumn = secondColumn()
		self.thirdColumn = thirdColumn()
		self.label = label
	}

	var body: some View {

		VStack(alignment: .leading, spacing: 8) {

			Text(label)
				.SettingsToggleSectionLabel()

			HStack(alignment: .top, spacing: 17) {

				VStack(alignment: .leading) {
					firstColumn
				}

				VStack(alignment: .leading) {
					secondColumn
				}

				VStack(alignment: .leading) {
					thirdColumn
				}
			}
		}
	}
}

/// Picks out the bundle id for the preferred shell
struct ComponentsSettingsPickPreferredShell: View {

	let shell: String

	let icon: NSImage?
	let name: String?

	let size: CGFloat = 16

	internal init(shellRef: String) {

		self.shell = shellRef

		// Get icon and name
		let keys: Set<URLResourceKey> = [
			.effectiveIconKey,
			.localizedNameKey
		]

		// Grabs the url for the shell's bundle id
		guard let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: shell) else {
			self.icon = nil
			self.name = nil
			return
		}

		// Retrieve resources
		let resources = SelectionHelper.getURLResources(url, keys)

		// Assign resources
		guard let iconUnwrapped = resources?.effectiveIcon as? NSImage else {
			self.icon = nil
			self.name = nil
			return
		}
		guard let nameUnwrapped = resources?.localizedName else {
			self.icon = nil
			self.name = nil
			return
		}

		self.icon = iconUnwrapped
		self.name = nameUnwrapped
	}

	var body: some View {
		HStack(alignment: .center) {
			Text(ContentManager.SettingsLabels.preferredShell)

			// Pick shell button
			Button {
				SecurityBookmarkHelper().pickShellApp()
			} label: {

				// Displays the shell as a label
				HStack(alignment: .center, spacing: 5) {

					if let icon = icon {
						Image(nsImage: icon)
							.resizable()
							.frame(width: size, height: size, alignment: .center)
							.padding([.top], 1)
					}

					if let name = name {
						Text(name)
					}
				}
				.offset(x: 0, y: 0.5)
				.padding([.horizontal], 2)
			}
		}
	}
}
