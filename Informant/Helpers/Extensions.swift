//
//  Extensions.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-13.
//

import Foundation
import SwiftUI

// MARK: - Extensions
// Use this file for storing any sort of extensions to classes.

// Provides the number of words of a string as an integer
extension String {
	var numberOfWords: Int {
		var count = 0
		let range = startIndex ..< endIndex
		enumerateSubstrings(in: range, options: [.byWords, .substringNotRequired, .localized]) { _, _, _, _ -> () in
			count += 1
		}
		return count
	}
}

// Capitalize each word without replacing an already all caps word.
// So instead of HTML -> Html it goes HTML -> HTML
extension String {
	var capitalizeEachWord: String {
		// break it into an array by delimiting the sentence using a space
		let breakupSentence = components(separatedBy: " ")
		var newSentence = ""

		// Loop the array and split each word from it's first letter. Capitalize the first letter and then
		// concaitenate
		for wordInSentence in breakupSentence {
			let firstLetter = wordInSentence.first!.uppercased()
			let remainingWord = wordInSentence.suffix(wordInSentence.count - 1)
			newSentence = "\(newSentence) \(firstLetter)\(remainingWord)"
		}

		// Remove space at beginning
		newSentence.removeFirst()

		// send it back up.
		return newSentence
	}
}

// Creates a blurred background effect for the main interface. Allows it to be called in SWiftUI
struct VisualEffectView: NSViewRepresentable {
	let material: NSVisualEffectView.Material
	let blendingMode: NSVisualEffectView.BlendingMode

	func makeNSView(context: Context) -> NSVisualEffectView {
		let visualEffectView = NSVisualEffectView()
		visualEffectView.translatesAutoresizingMaskIntoConstraints = false
		visualEffectView.material = material
		visualEffectView.state = NSVisualEffectView.State.active
		visualEffectView.blendingMode = blendingMode

		return visualEffectView
	}

	func updateNSView(_ visualEffectView: NSVisualEffectView, context: Context) {
		visualEffectView.material = material
		visualEffectView.blendingMode = blendingMode
	}
}
