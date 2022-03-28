//
//  +ParagraphStyle.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 19/3/22.
//

import Foundation
import UIKit

extension NSParagraphStyle {
    
    static let nonLineBreak: NSParagraphStyle = {
        $0.lineBreakMode = .byWordWrapping
        return $0
    }(NSMutableParagraphStyle())
    
    static let lineBreak: NSParagraphStyle = {
        $0.lineBreakMode = .byWordWrapping
        return $0
    }(NSMutableParagraphStyle())
    
    static let chord: NSParagraphStyle = {
        $0.lineBreakMode = .byTruncatingTail
        $0.lineHeightMultiple = 0.8
        $0.lineSpacing = 0.8
        return $0
    }(NSMutableParagraphStyle())
}
