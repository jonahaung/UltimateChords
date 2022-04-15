//
//  WidthFittingTextView.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 22/3/22.
//

import UIKit
import SwiftUI

class WidthFittingTextView: TextView {
    
    private var isDinamicFontSizeEnabled = UserDefault.LyricViewer.isDinamicFontSizeEnabled
    
    private func adjustByDecreasingFontSize() {
        guard let mutable = attributedText?.mutable else { return }
        let preferredWidth = UIScreen.main.bounds.size.width - 10 - (textContainer.lineFragmentPadding*2)
        mutable.adjustFontSize(to: preferredWidth)
        if mutable != attributedText {
            self.attributedText = mutable
        }
    }
    
    func update(_ newText: NSAttributedString, adjustFontSize: Bool) {
        if isDinamicFontSizeEnabled != adjustFontSize {
            self.isDinamicFontSizeEnabled = adjustFontSize
            if adjustFontSize {
                adjustByDecreasingFontSize()
            }else {
                attributedText = newText
                
            }
        } else {
            if attributedText?.string != newText.string {
                attributedText = newText
                if adjustFontSize {
                    adjustByDecreasingFontSize()
                }
            }
        }
    }
}

extension NSMutableAttributedString {
    
    private func adjustFontRatio(factor: CGFloat) {
       self.enumerateAttribute(.font, in: NSRange(location: 0, length: self.length)) { value, range, pointer in
           if let font = value as? UIFont {
               self.removeAttribute(.font, range: range)
               self.addAttribute(.font, value: font.withSize(font.pointSize * factor), range: range)
           }
       }
   }
   
   func adjustFontSize(to availiableWidth: CGFloat) {
       var percent: CGFloat = 1
       beginEditing()
       while availiableWidth < self.size(for: CGSize(width: .greatestFiniteMagnitude, height: availiableWidth*2)).width  {
           percent -= 0.01
           adjustFontRatio(factor: percent)
       }
       endEditing()
   }
}
