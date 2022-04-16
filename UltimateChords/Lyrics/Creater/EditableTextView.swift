//
//  EditableTextView.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 28/3/22.
//

import UIKit
import NaturalLanguage

class EditableTextView: TextView {
    
    private lazy var toolBar = ToolbarInputAccessory()
    
    override func commonInit() {
        super.commonInit()
        keyboardDismissMode = .interactive
        markedTextStyle = [.backgroundColor: UIColor.systemYellow.withAlphaComponent(0.5)]
        delegate = self
    }
    
    func configureToolbar() {
        toolBar.configure(textView: self)
    }
}

extension EditableTextView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        updateFont()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == " " && markedTextRange != nil {
            unmarkText()
            return false
        }
        
        return true
    }
}
extension EditableTextView {
    
    func updateFont() {
        guard hasText else { return }
        
        print("didChange")
        var tags = [XTag]()
        text.enumerateSubstrings(in: text.startIndex..<text.endIndex, options: .byLines) {
            (substring, substringRange, _, _) in
            if let substring = substring {
                let nsRange = NSRange(substringRange, in: self.text)
                let string = String(substring)
                tags.append(.init(string: string, range: nsRange, font: XFont.body(for: string)))
            }
        }
        RegularExpression.chordPattern.enumerateMatches(in: text, range: text.range()) { result, _, _ in
            if let result = result {
                let range = result.range
                let str = (text as NSString).substring(with: range)
                let tag = XTag(string: String(str), range: range, foregroundColor: .systemBlue)
                tags.append(tag)
            }
        }
        tags.forEach {
            textStorage.addAttributes($0.attributes, range: $0.range)
        }
    }
    
}

extension EditableTextView {
    
    override func setMarkedText(_ markedText: String?, selectedRange: NSRange) {
        super.setMarkedText(markedText, selectedRange: selectedRange)
    }
    
    func insert(text: String) {
        insertText(text.newLine)
        scrollToBottom()
    }
    
    func scrollToBottom() {
        let length = attributedText.string.utf16.count
        let range = NSMakeRange(length-1, 0)
        scrollRangeToVisible(range)
        selectedTextRange = self.textRange(from: endOfDocument, to: endOfDocument)
    }
}
