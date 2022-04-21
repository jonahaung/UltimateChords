//
//  EditableTextView.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 28/3/22.
//

import UIKit

class EditableTextView: TextView {
    
    private lazy var toolBar = ToolbarInputAccessory()
    private var tags = [XTag]()
    
    override func commonInit() {
        super.commonInit()
        keyboardDismissMode = .interactive
    }
    
    func configureToolbar() {
        toolBar.configure(textView: self)
    }
}

extension EditableTextView {
    
    func reset() {
        tags.removeAll()
    }
    
    func detectChords() {
        var newTags = [XTag]()
        text.enumerateSubstrings(in: text.startIndex..<text.endIndex, options: .byLines) {
            (substring, substringRange, _, _) in
            if let substring = substring {
                let nsRange = NSRange(substringRange, in: self.text)
                let string = String(substring)
                let tag = XTag.init(string: string, range: nsRange, font: XFont.body(for: string))
                if !self.tags.contains(tag) {
                    newTags.append(tag)
                }
            }
        }
        
        RegularExpression.chordPattern.enumerateMatches(in: text, range: text.nsRange()) { result, _, _ in
            if let result = result {
                let range = result.range
                let str = (text as NSString).substring(with: range)
                let tag = XTag(string: String(str), range: range, foregroundColor: .systemBlue)
                if !self.tags.contains(tag) {
                    newTags.append(tag)
                }
            }
        }
        if newTags.isEmpty == false {
            newTags.forEach {
                textStorage.addAttributes($0.attributes, range: $0.range)
            }
            self.tags += newTags
        }
    }
}

extension EditableTextView {
    
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
