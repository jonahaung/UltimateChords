//
//  +Song.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 28/3/22.
//

import UIKit

extension Song {
    
    enum DisplayMode: String, CaseIterable {
        case Default, Copyable, Editing, TextOnly
        func next() -> DisplayMode {
            switch self {
            case .Default:
                return .Copyable
            case .Copyable:
                return .Editing
            case .Editing:
                return .TextOnly
            case .TextOnly:
                return .Default
            }
        }
    }
    
    var attributedText: NSAttributedString {
        AttributedString.displayText(for: self, with: displayMode)
    }

    mutating func setDisplayMode(_ newValue: DisplayMode) {
        self.displayMode = newValue
    }

}

extension Song {
    
//    private func getChordTags() -> [ChordTag] {
//        let nsString = rawText as NSString
//        var tags = [ChordTag]()
//        RegularExpression.chordPattern.enumerateMatches(in: rawText, options: [], range: rawText.range()) { result, matches, pointer in
//            guard let result = result else {
//                return
//            }
//            let subRange = result.range
//            let subString = nsString.substring(with: subRange).replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "")
//            let tag = ChordTag(chord: subString, range: subRange)
//            tags.append(tag)
//        }
//        return tags
//    }
    
//    private func createTitle() -> NSMutableAttributedString {
//        let title = NSAttributedString(rawText, style: .title).mutable
//        title.append(.init("\r" + (self.artist?.newLine ?? ""), style: .subheadline))
//        return title
//    }
    
//    func chordTags() -> [ChordTag]? {
//        var items = [ChordTag]()
//        RegularExpression.chordPattern.matches(in: rawText, range: rawText.range()).forEach { match in
//            let nsString = rawText as NSString
//            let tagRange = match.range // (location: 20, length: 3]
//            let subString = nsString.substring(with: tagRange) // [G]
//            let chord = subString
//            let item = ChordTag.init(chord: chord, range: tagRange)
//            items.append(item)
//        }
//
//        return items
//    }
    
    

}

