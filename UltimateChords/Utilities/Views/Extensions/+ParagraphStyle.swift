//
//  +ParagraphStyle.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 19/3/22.
//

import Foundation
import UIKit

extension NSParagraphStyle {
    static let lineBreak: NSParagraphStyle = {
        $0.lineBreakMode = .byWordWrapping
//        $0.lineHeightMultiple = 0.9
//        $0.lineSpacing = 0.9
        return $0
    }(NSMutableParagraphStyle())
    static let nonLineBreak: NSParagraphStyle = {
        $0.lineBreakMode = .byTruncatingTail
        $0.alignment = NSTextAlignment.left
        $0.lineHeightMultiple = 0.9
        $0.lineSpacing = 0.9
        return $0
    }(NSMutableParagraphStyle())

}
