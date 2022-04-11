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
    
    override var text: String! {
        didSet {
            delegate?.textViewDidChange?(self)
        }
    }
    
    override func insertText(_ text: String) {
        super.insertText(text)
        delegate?.textViewDidChange?(self)
    }
    
    override func paste(_ sender: Any?) {
        super.paste(sender)
        delegate?.textViewDidChange?(self)
    }
    override func cut(_ sender: Any?) {
        super.cut(sender)
        delegate?.textViewDidChange?(self)
    }
    
    
    weak var delegate2: EditableTextViewDelegate?
    private var tags = [ChordTag]()
    var isChordMode = false
    
    func setTupEditing() {
        self.inputAccessoryView = keyboardToolbar
        cameraInputView.textField = self
    }
}

extension EditableTextView {
    
    @objc private func cameraDidTap() {
        self.inputAccessoryView = cameraToolbar
        self.inputView = cameraInputView
        cameraInputView.startCamera()
        self.reloadInputViews()
    }
    
    @objc private func keyboardDidTap() {
        self.inputAccessoryView = keyboardToolbar
        self.inputView = nil
        self.reloadInputViews()
    }
    
    @objc private func doneDidTap() {
        self.resignFirstResponder()
        keyboardDidTap()
    }
}

extension EditableTextView {
    
    func apply(tags: [ChordTag]) {
        let mutable = attributedText.mutable
        tags.forEach { tag in
            mutable.addAttributes([.foregroundColor: UIColor.systemBlue, .font: XFont.chord()], range: tag.range)
        }
        self.attributedText = mutable
    }
}
