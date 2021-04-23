//
//  FileObject.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-17.
//

import Cocoa
import Foundation

class FileObject {
	public var filePath: String?
	public var fileName: String?
	public var fileType: String?
	public var fileTypeIcon: NSImage?
	public var fileSize: Int?

	private var fileDateCreated: Date?
	private var fileDateModified: Date?
	public var fileDateCreatedAsString: String?
	public var fileDateModifiedAsString: String?

	// This init grabs all relevant information for the file
	init(url: String) {
		filePath = url

		// Grabs the file's attributes
		guard let fileAttributes = getFileAttributes(path: filePath!) else {
			return
		}

		// Grabs file name using last part of path
		if filePath!.last == "/" {
			let directoryPath = String(filePath!.dropLast())
			fileName = URL(fileURLWithPath: directoryPath).lastPathComponent
		} else {
			fileName = URL(fileURLWithPath: filePath!).lastPathComponent
		}

		// Inject attributes into the object
		fileType = fileAttributes[FileAttributeKey.type] as? String
		fileTypeIcon = NSWorkspace.shared.icon(forFile: filePath!)
		fileSize = fileAttributes[FileAttributeKey.size] as? Int
		fileDateCreated = fileAttributes[FileAttributeKey.creationDate] as? Date
		fileDateModified = fileAttributes[FileAttributeKey.modificationDate] as? Date

		// Format dates
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .medium
		dateFormatter.timeStyle = .short
		dateFormatter.doesRelativeDateFormatting = true

		fileDateCreatedAsString = dateFormatter.string(from: fileDateCreated!)
		fileDateModifiedAsString = dateFormatter.string(from: fileDateModified!)
	}

	// This function will take in a url string and provide a file attribute object which can be
	// then used to grab info, such as name, size, etc. Returns nil if nothing is found
	func getFileAttributes(path: String) -> [FileAttributeKey: Any]? {
		do {
			return try FileManager.default.attributesOfItem(atPath: path)
		} catch {
			return nil
		}
	}
}

class FileCollection: ObservableObject {

	public enum CollectionType {
		case Single
		case Multi
		case Directory
	}

	@Published public var files: [FileObject] = []
	@Published public var summary: FileObject?
	public let collectionType: CollectionType?

	init(collectionType: CollectionType, filePaths: [String]) {
		self.collectionType = collectionType

		for path in filePaths {
			files.append(FileObject(url: path))
		}
	}
}
