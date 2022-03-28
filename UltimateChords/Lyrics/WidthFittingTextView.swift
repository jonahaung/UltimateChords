//
//  WidthFittingTextView.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 22/3/22.
//

import UIKit

class WidthFittingTextView: TextView {

    var isDinamicFontSizeEnabled = true

    
    override func layoutSubviews() {
        super.layoutSubviews()
        if hasText {
            adjustFontSize()
        }
    }
    
    var fontSizePercent: CGFloat = 1 {
        didSet {
            updateAttributes()
        }
    }
    
    private func updateAttributes() {
        
        textStorage.enumerateAttributes(in: self.text.range()) { attr, range, pointer in
            var attr = attr
            let oldFont = attr[.font] as? UIFont ?? XFont.body(for: self.text)
            attr[.font] = oldFont.withSize(oldFont.pointSize * fontSizePercent)
            
            let newString = textStorage.attributedSubstring(from: range).string
            
            textStorage.replaceCharacters(in: range, with: NSAttributedString(string: newString, attributes: attr))
        }
        
    }
    
    func adjustFontSize() {
        guard isDinamicFontSizeEnabled, !attributedText.string.isEmpty else { return }
        self.fontSizePercent = 1
        let containerSize = textContainer.size
        let largestSize = CGSize(width: .greatestFiniteMagnitude, height: containerSize.height)
        while (containerSize.width) < attributedText.size(for: largestSize).width {
            self.fontSizePercent -= 0.01
        }
    }
    
    
    
}
