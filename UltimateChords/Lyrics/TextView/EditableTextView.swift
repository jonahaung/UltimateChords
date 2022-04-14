//
//  EditableTextView.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 28/3/22.
//

import UIKit

class EditableTextView: TextView {
    
    private let toolBar = ToolbarInputAccessory()
    
    override func commonInit() {
        super.commonInit()
        keyboardDismissMode = .interactive
        typingAttributes = [.font: UIFont(name: "NotoSansMonoExtraCondensed-Medium", size: UIFont.systemFontSize)!, .foregroundColor: UIColor.label]
        
        
    }
    
    override func insertText(_ text: String) {
        super.insertText(text)
        textDidChange()
    }
    
    override func paste(_ sender: Any?) {
        super.paste(sender)
        textDidChange()
    }
    
    override func cut(_ sender: Any?) {
        super.cut(sender)
        textDidChange()
    }
    
    func setupToolbar() {
        toolBar.configure(textView: self)
    }
}

extension EditableTextView {
    
    func textDidChange() {
        guard hasText else { return }
        var tags = [ChordTag]()
        
        RegularExpression.chordPattern.enumerateMatches(in: text, range: text.range()) { result, flag, point in
            if let result = result {
                let range = result.range
                let str = (text as NSString).substring(with: range)
                let tag = ChordTag(chord: String(str), range: range)
                tags.append(tag)
            }
        }
        
        tags.forEach { tag in
            textStorage.addAttributes(tag.chordAttributes, range: tag.range)
        }
    }
}
