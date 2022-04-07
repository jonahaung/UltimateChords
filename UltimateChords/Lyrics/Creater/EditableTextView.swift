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
        font = XFont.universal(for: .body)
        self.inputAccessoryView = keyboardToolbar
        cameraInputView.textField = self
    }
    
    private lazy var keyboardToolbar: UIToolbar = {
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneDidTap))
        let camera = UIBarButtonItem(image: UIImage(systemName: XIcon.Icon.doc_text_viewfinder.systemName), style: .plain, target: self, action: #selector(cameraDidTap))
        $0.items = [flexible, camera, doneBtn]
        $0.sizeToFit()
        return $0
    } (UIToolbar(frame: .init(x: 0, y: 0, width: 320, height: 44)))
    
    private lazy var cameraToolbar: UIToolbar = {
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let keyboardBtn = UIBarButtonItem(image: UIImage(systemName: XIcon.Icon.keyboard.systemName), style: .plain, target: self, action: #selector(keyboardDidTap))
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneDidTap))
        $0.items = [flexible, keyboardBtn, doneBtn]
        $0.sizeToFit()
        return $0
    }(UIToolbar(frame: .init(x: 0, y: 0, width: 320, height: 44)))
    
    private let cameraInputView = CameraKeyboard()
    
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
extension EditableTextView {
    @objc
    private func cameraDidTap() {
        self.inputAccessoryView = cameraToolbar
        self.inputView = cameraInputView
        cameraInputView.startCamera()
        self.reloadInputViews()
    }
    
    @objc
    private func keyboardDidTap() {
        self.inputAccessoryView = keyboardToolbar
        self.inputView = nil
        self.reloadInputViews()
    }
    
    @objc
    private func doneDidTap() {
        self.resignFirstResponder()
        keyboardDidTap()
    }
}
