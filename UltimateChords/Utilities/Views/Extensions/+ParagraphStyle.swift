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
        $0.lineBreakMode = .byClipping
        $0.alignment = NSTextAlignment.left
        $0.allowsDefaultTighteningForTruncation = false
        return $0
    }(NSMutableParagraphStyle())
}
