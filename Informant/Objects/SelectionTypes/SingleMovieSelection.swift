//
//  SingleMovieSelection.swift
//  Informant
//
//  Created by Ty Irvine on 2021-06-21.
//

import Foundation

class SingleMovieSelection: SingleSelection {

	var codecs: String?
	var duration: String?
	var colorProfile: String?
	var dimensions: String?
	var audioBitrate: String?
	var videoBitrate: String?

	required init(_ urls: [String], selection: SelectionType = .Movie, parameters: [SelectionParameters] = [.grabSize]) {

		// Initialize basic selection
		super.init(urls, selection: selection, parameters: parameters)

		// These are the values we want to acccess
		let keys: NSArray = [
			kMDItemCodecs!,
			kMDItemDurationSeconds!,
			kMDItemProfileName!,
			kMDItemPixelWidth!,
			kMDItemPixelHeight!,
			kMDItemVideoBitRate!,
			kMDItemAudioBitRate!,
			kMDItemAudioSampleRate!
		]

		// Gather basic metadata for movie
		if let metadata = SelectionHelper.getURLMetadata(url, keys: keys) {

			// Codecs
			if let codecs = metadata[kMDItemCodecs] as? [String] {
				self.codecs = codecs.joined(separator: ", ")
			}

			// Duration
			if let duration = metadata[kMDItemDurationSeconds] {
				self.duration = SelectionHelper.formatDuration(duration)
			}

			// Color Profile
			if let colorProfile = metadata[kMDItemProfileName] {
				self.colorProfile = String(describing: colorProfile)
			}

			// Dimensions
			if let dimensions = SelectionHelper.getMovieDimensions(url: url) {
				self.dimensions = dimensions
			}

			// Audio bitrate
			if let audioBitrate = metadata[kMDItemAudioBitRate] as? Int64 {
				self.audioBitrate = SelectionHelper.formatBitrate(audioBitrate, unit: .None)
			}

			// Video bitrate
			if let videoBitrate = metadata[kMDItemVideoBitRate] as? Int64 {
				self.videoBitrate = SelectionHelper.formatBitrate(videoBitrate, unit: .Mb)
			}
		}
	}
}
