//
//  Popover.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-22.
//

import SwiftUI

struct PopoverSingleFile: View {

	var file: FileObject

//	init() {
//		file = interfaceData!.fileCollection!.files[0]
//	}

	var body: some View {
		VStack(alignment: .leading) {

			ComponentsPopoverHeader(
				headerIcon: file.fileTypeIcon!,
				headerTitle: file.fileName!,
				headerSubtitle: file.fileDateModifiedAsString!
			)

			Divider().padding(.bottom, 10)

			VStack(alignment: .leading, spacing: 20) {
				// Kind - Size
				HStack {
					ComponentsPopoverFileAttribute(label: "Kind", value: String(file.fileType!))
					ComponentsPopoverFileAttribute(label: "Size", value: String(file.fileSize!))
				}

				// Created
				ComponentsPopoverFileAttribute(label: "Created", value: file.fileDateCreatedAsString!)

				// Path
				ComponentsPopoverFileAttribute(label: "Path", value: file.filePath!)
			}
		}
	}
}
