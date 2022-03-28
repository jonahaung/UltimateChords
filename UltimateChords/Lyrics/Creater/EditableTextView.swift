//
//  EditableTextView.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 28/3/22.
//

import UIKit

class EditableTextView: TextView {
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if !isEditable {
            if let first = touches.first {
                let location = first.location(in: self)
                if let word = self.getWordAtPosition(location), !word.isWhitespace {
                    selectedTextRange = self.getWordRangeAtPosition(location)
                }
            }
        }
    }

    func setTupEditing() {
        UIMenuController.shared.menuItems = [
            .init(title: "Add Chord", action: #selector(highlightedAction(_:))),
            .init(title: "Remove Chord", action: #selector(removeChords(_:))),
        ]
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        guard selectedTextRange != nil else { return false }

        if action == #selector(highlightedAction(_:)) || action == #selector(removeChords(_:)) {
             return true
         }
         return false
    }

    
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
    @objc func removeChords(_ sender: Any) {
        isEditable.toggle()
        if isFirstResponder {
            resignFirstResponder()
            self.attributedText = ChordPro.parse(string: self.text).attributedText
        }else {
            becomeFirstResponder()
        }
        
    }
    
}
