//
//  ChordTag.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 23/3/22.
//

import UIKit

struct ChordTag {
    var name : String
    var range: NSRange
    var data : [String: Any] = [:]
    var customTextAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.link]
}
