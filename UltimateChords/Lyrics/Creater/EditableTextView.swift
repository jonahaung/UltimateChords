//
//  EditableTextView.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 28/3/22.
//

import UIKit
import SwiftyChords

protocol EditableTextViewDelegate: AnyObject {
    
    func textView(textView: EditableTextView, didTap add: Bool)
}
class EditableTextView: TextView {

    var isChordMode = false
    weak var delegagte2: EditableTextViewDelegate?
    private var tags = [ChordTag]()
    
    func setTupEditing() {
//        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
//        addGestureRecognizer(tap)
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        guard selectedTextRange != nil else { return false }

        if action == #selector(addChord(_:)) || action == #selector(addChord(_:)) || action == #selector(removeChord(_:)) {
             return true
         }
         return false
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard let last = Array(touches).last else { return }
        let location = last.location(in: self)
        if let range = self.getWordRangeAtPosition(location) {
            self.selectedTextRange = range
            let add = UIMenuItem(title: "+ Chord", action: #selector(addChord(_:)))
            let remove = UIMenuItem(title: "remove", action: #selector(removeChord(_:)))
            UIMenuController.shared.menuItems = [add, remove]
            UIMenuController.shared.showMenu(from: self, rect: .init(origin: location, size: .zero))
        }
    }
    
    @objc private func addChord(_ sender: Any) {
        delegagte2?.textView(textView: self, didTap: true)
    }
    
    @objc private func removeChord(_ sender: Any) {
        delegagte2?.textView(textView: self, didTap: false)
    }
    
    func addChord(chord: Chord) {
        let oldSelected = selectedRange
        selectedRange.length = 0
        
        let key = chord.key.rawValue
        var suff = chord.suffix.rawValue
        if chord.suffix == .major {
            suff = ""
        } else if chord.suffix == .minor {
            suff = "m"
        }
        let x = "[" + key + suff + "]"
        self.insertText(x)
        self.delegate?.textViewDidChange?(self)
        
        if !self.tags.isEmpty {
            self.text = self.attributedText.string
        }
        tags = AttributedString.getChordTags(for: self.text)
        let mutable = self.attributedText.mutable
        tags.forEach { tag in
            mutable.addAttributes(tag.customTextAttributes, range: tag.range)
        }
        self.attributedText = mutable
        self.selectedRange = oldSelected
    }
    
}
