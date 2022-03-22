//
//  +UITextView.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 21/3/22.
//

import UIKit

extension UITextView {
 
    func boundingFrame(ofTextRange textRange: UITextRange) -> CGRect {
        let rects = selectionRects(for: textRange)
        return rects.map{ $0.rect }.reduce(CGRect.null) { partialResult, rect in
            partialResult.union(rect)
        }
        var returnRect = CGRect.zero
        for thisSelRect in rects {
            if thisSelRect == rects.first {
                returnRect = thisSelRect.rect
            } else {
                if thisSelRect.rect.size.width > 0 {
                    returnRect.origin.y = min(returnRect.origin.y, thisSelRect.rect.origin.y)
                    returnRect.size.height += thisSelRect.rect.size.height
                }
            }
        }
        return returnRect
    }
 
}
