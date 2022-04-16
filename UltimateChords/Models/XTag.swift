//
//  ChordTag.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 23/3/22.
//

import UIKit

struct XTag {
    var string : String
    var range: NSRange
    var data : [String: Any] = [:]
    var font = XFont.chord()
    var foregroundColor = UIColor.label
    
    var attributes: [NSAttributedString.Key: Any] { [.font: font, .foregroundColor: foregroundColor]}
//    var chordAttributes: [NSAttributedString.Key: Any] = [.font: XFont.chord(), .foregroundColor: UIColor.systemPink]
//    var baselineAttributes: [NSAttributedString.Key: Any] = [.font: XFont.chord(), .foregroundColor: UIColor.systemPink, .baselineOffset: 10]
}

extension XTag: Equatable {
    static func == (lhs: XTag, rhs: XTag) -> Bool {
        lhs.string == rhs.string && lhs.range == rhs.range
    }
}
