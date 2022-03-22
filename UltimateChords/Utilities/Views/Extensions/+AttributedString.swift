//
//  +AttributedText.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 19/3/22.
//

import UIKit

extension NSAttributedString {
    
    var mutable: NSMutableAttributedString { NSMutableAttributedString(attributedString: self) }
    var attributes: [NSMutableAttributedString.Key: Any] { self.attributes(at: 0, effectiveRange: nil) }
    
    func size(for largestSize: CGSize) -> CGSize {
        let framesetter = CTFramesetterCreateWithAttributedString(self)
        return CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRange(), nil, largestSize, nil)
    }
}
