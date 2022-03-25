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


extension UITextView {
    
    func getWordRangeAtPosition(_ point: CGPoint) -> UITextRange? {
        if let textPosition = self.closestPosition(to: point) {
            return tokenizer.rangeEnclosingPosition(textPosition, with: .word, inDirection: .init(rawValue: 1))
        }
        return nil
    }
    
    func getSentenceRangeAtPosition(_ point: CGPoint) -> UITextRange? {
        if let textPosition = self.closestPosition(to: point) {
            return tokenizer.rangeEnclosingPosition(textPosition, with: .sentence, inDirection: .init(rawValue: 1))
        }
        return nil
    }
    func getLineRangeAtPosition(_ point: CGPoint) -> UITextRange? {
        if let textPosition = self.closestPosition(to: point) {
            return tokenizer.rangeEnclosingPosition(textPosition, with: .line, inDirection: .init(rawValue: 1))
        }
        return nil
    }
    func getCharacterRangeAtPosition(_ point: CGPoint) -> UITextRange? {
        if let textPosition = self.closestPosition(to: point) {
            return tokenizer.rangeEnclosingPosition(textPosition, with: .character, inDirection: .init(rawValue: 1))
        }
        return nil
    }
    func getParagraphRangeAtPosition(_ point: CGPoint) -> UITextRange? {
        if let textPosition = self.closestPosition(to: point) {
            return tokenizer.rangeEnclosingPosition(textPosition, with: .paragraph, inDirection: .init(rawValue: 1))
        }
        return nil
    }
    func getWordAtPosition(_ point: CGPoint) -> String? {
        if let range = getWordRangeAtPosition(point) {
            return self.text(in: range)
        }
        return nil
    }
    func getAttributsAtPosition(_ point: CGPoint) -> [NSAttributedString.Key: Any]? {
        let characterIndex = layoutManager.characterIndex(for: point, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        if let attributes = attributedText?.attributes(at: characterIndex, effectiveRange: nil) {
            return attributes
        }
        return nil
    }
}
