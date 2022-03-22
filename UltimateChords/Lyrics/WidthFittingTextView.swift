//
//  WidthFittingTextView.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 22/3/22.
//

import UIKit

protocol WidthFittingTextViewDelegate: AnyObject {
    func textViewDidChange(_ textView: WidthFittingTextView)
    func textView(_ textView: WidthFittingTextView, didAdjustFontSize fontSize: CGFloat)
}
class WidthFittingTextView: UITextView {
    
    weak var widthFittingTextViewDelegate: WidthFittingTextViewDelegate?
    
    init() {
        super.init(frame: .zero, textContainer: nil)
        keyboardDismissMode = .interactive
        textContainer.lineFragmentPadding = 5
        showsVerticalScrollIndicator = false
        delegate = self
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private var fontSize: CGFloat{
        get {
            return font?.pointSize ?? 0
        }
        set {
            guard newValue != fontSize else { return }
            font = font?.withSize(newValue)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !isEditable {
            if widthFittingTextViewDelegate != nil {
                adjustFontSize()
            }
        }
    }
    
    private func adjustFontSize() {
        let containerSize = textContainer.size
        let largestSize = CGSize(width: .greatestFiniteMagnitude, height: containerSize.height)
        if isEditable {
            fontSize = 30
        }
        while (containerSize.width - textContainer.lineFragmentPadding) < attributedText.size(for: largestSize).width {
            fontSize -= 0.5
        }
        widthFittingTextViewDelegate?.textView(self, didAdjustFontSize: fontSize)
    }
    
    override func paste(_ sender: Any?) {
        super.paste(sender)
        adjustFontSize()
    }

    override func cut(_ sender: Any?) {
        super.cut(sender)
        adjustFontSize()
    }

    override func insertText(_ text: String) {
        super.insertText(text)
        adjustFontSize()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if let first = touches.first {
            let location = first.location(in: self)
            selectedTextRange = self.getCharacterRangeAtPosition(location)
        }
    }
    
//    func textViewDidChangeSelection(_ textView: UITextView) {
//        guard let selectedTextRange = self.selectedTextRange else { return }
//        guard let paragraphRange = self.tokenizer.rangeEnclosingPosition(selectedTextRange.start, with: .character, inDirection: .init(rawValue: 0)) else { return }
//                self.selectedTextRange = paragraphRange
//    }
}

extension WidthFittingTextView: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        adjustFontSize()
        widthFittingTextViewDelegate?.textViewDidChange(self)
    }
}


