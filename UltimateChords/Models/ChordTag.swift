//
//  ChordTag.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 23/3/22.
//

import UIKit

struct ChordTag {
    var chord : String
    var range: NSRange
    var data : [String: Any] = [:]
    var chordAttributes: [NSAttributedString.Key: Any] = [.font: XFont.chord(), .foregroundColor: UIColor.systemPink]
    var baselineAttributes: [NSAttributedString.Key: Any] = [.font: XFont.chord(), .foregroundColor: UIColor.systemPink, .baselineOffset: 10]
}

extension ChordTag: Equatable {
    static func == (lhs: ChordTag, rhs: ChordTag) -> Bool {
        lhs.chord == rhs.chord && lhs.range == rhs.range
    }
}
