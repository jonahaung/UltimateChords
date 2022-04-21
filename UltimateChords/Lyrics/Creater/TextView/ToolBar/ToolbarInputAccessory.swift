//
//  ToolbarInputAccessory.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 14/4/22.
//

import UIKit

class ToolbarInputAccessory {
    
    // Toolbars
    private lazy var keyboardToolbar: UIToolbar = {
        $0.clear()
        $0.items = [.flexible, guitarButton, doneButton]
        $0.sizeToFit()
        return $0
    } (UIToolbar(frame: .init(x: 0, y: 0, width: 320, height: 44)))
    
    private lazy var chordToolbar: UIToolbar = {
        $0.clear()
        $0.items = [.flexible, keyboardButton, doneButton]
        $0.sizeToFit()
        return $0
    } (UIToolbar(frame: .init(x: 0, y: 0, width: 320, height: 44)))
    
    private lazy var doneButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneDidTap))
    
    private lazy var keyboardButton = UIBarButtonItem(image: UIImage(systemName: XIcon.Icon.keyboard.systemName), style: .done, target: self, action: #selector(keyboardDidTap))
    private lazy var guitarButton = UIBarButtonItem(image: UIImage(systemName: XIcon.Icon.music_note_list.systemName), style: .done, target: self, action: #selector(guitarDidTap))

    weak var textView: UITextView?
    private lazy var chordInputView = ChordsInputView()
    
    func configure(textView: UITextView) {
        textView.inputAccessoryView = keyboardToolbar
        chordInputView.textView = textView
        self.textView = textView
    }
    
    @objc private func keyboardDidTap() {
        textView?.inputAccessoryView = keyboardToolbar
        textView?.inputView = nil
        textView?.reloadInputViews()
    }
    
    @objc private func guitarDidTap() {
        textView?.inputAccessoryView = chordToolbar
        textView?.inputView = chordInputView
        textView?.reloadInputViews()
    }
    @objc private func doneDidTap() {
        textView?.resignFirstResponder()
        keyboardDidTap()
    }
}

extension UIBarButtonItem {
    static let flexible = UIBarButtonItem(systemItem: .flexibleSpace)
}

extension UIToolbar {
    
    func clear() {
        setShadowImage(UIImage(), forToolbarPosition: .bottom)
        backgroundColor = .systemBackground
        isTranslucent = false
    }
}
