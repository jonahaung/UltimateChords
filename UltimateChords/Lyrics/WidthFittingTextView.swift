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
    var isDinamicFontSizeEnabled = true
    
    init() {
        super.init(frame: .zero, textContainer: nil)
        keyboardDismissMode = .interactive
        textContainerInset = .zero
        textContainer.lineFragmentPadding = 8
        showsVerticalScrollIndicator = false
        dataDetectorTypes = []
        delegate = self
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if hasText {
            adjustFontSize()
        }
    }
    
    var fontSizePercent: CGFloat = 1 {
        didSet {
            guard oldValue != fontSizePercent else { return }
            updateAttributes()
        }
    }
    
    private func updateAttributes() {
        textStorage.beginEditing()
        textStorage.enumerateAttributes(in: self.text.range()) { attr, range, pointer in
            var attr = attr
            let oldFont = attr[.font] as? UIFont ?? XFont.body(for: self.text)
            attr[.font] = oldFont.withSize(oldFont.pointSize * fontSizePercent)
            
            let newString = textStorage.attributedSubstring(from: range).string
            
            textStorage.replaceCharacters(in: range, with: NSAttributedString(string: newString, attributes: attr))
        }
        textStorage.endEditing()
    }
    
    private func adjustFontSize() {
        guard isDinamicFontSizeEnabled, !attributedText.string.isEmpty else { return }
        self.fontSizePercent = 1
        let containerSize = textContainer.size
        let largestSize = CGSize(width: .greatestFiniteMagnitude, height: containerSize.height)
        while (containerSize.width) < attributedText.size(for: largestSize).width {
            self.fontSizePercent -= 0.01
        }
    }
    
    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesEnded(touches, with: event)
//
//        if !isEditable {
//            if let first = touches.first {
//                let location = first.location(in: self)
//                if let word = self.getWordAtPosition(location), !word.isWhitespace {
//                    selectedTextRange = self.getWordRangeAtPosition(location)
//                }
//
//            }
//        }
//    }
//
//
//    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
//        guard selectedTextRange != nil else { return false }
//
//        if action == #selector(highlightedAction(_:)) ||
//                 action == #selector(UIResponderStandardEditActions.delete(_:)) {
//             return true
//         }
//         return false
//    }

    
    override func delete(_ sender: Any?) {
        textStorage.deleteCharacters(in: selectedRange)
        selectedRange.length = 0
        delegate?.textViewDidChange?(self)
    }
    
    @objc func highlightedAction(_ sender: Any) {
        let random = ["[G]", "[Am]", "[F]", "[C]", "[Dm]", "[Em]"]
        self.textStorage.insert(NSAttributedString(string: random.randomElement()!, attributes: typingAttributes), at: selectedRange.location)
        delegate?.textViewDidChange?(self)
    }

}

extension WidthFittingTextView: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        adjustFontSize()
        widthFittingTextViewDelegate?.textViewDidChange(self)
    }
}


