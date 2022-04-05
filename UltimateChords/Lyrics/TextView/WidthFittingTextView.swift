//
//  WidthFittingTextView.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 22/3/22.
//

import UIKit
protocol WidthFittingTextViewDelegate: AnyObject {
    func textView(textView: WidthFittingTextView, didAdjustFontSize text: NSAttributedString)
}
class WidthFittingTextView: TextView {
    
    weak var delegate2: WidthFittingTextViewDelegate?
    var isDinamicFontSizeEnabled = true {
        didSet {
            guard oldValue != isDinamicFontSizeEnabled else { return }
            adjustFontSizeIfNeeded()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        adjustFontSizeIfNeeded()
    }
    
    private func adjustFontSizeIfNeeded() {
        if delegate2 != nil && isDinamicFontSizeEnabled {
            adjustByDecreasingFontSize()
        }
    }
    private func adjustByDecreasingFontSize() {
        guard !attributedText.string.isEmpty else { return }
        let mutable = attributedText.mutable
        var containerSize = textContainer.size
        containerSize.width -= textContainer.lineFragmentPadding*2
        mutable.adjustFontSize(to: containerSize.width)
        self.attributedText = mutable
    }
    
}
