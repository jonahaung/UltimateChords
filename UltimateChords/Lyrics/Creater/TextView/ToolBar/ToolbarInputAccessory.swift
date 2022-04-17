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
        $0.items = [guitarButton, .flexible, doneButton]
        $0.sizeToFit()
        return $0
    } (UIToolbar(frame: .init(x: 0, y: 0, width: 320, height: 44)))
    
    private lazy var chordToolbar: UIToolbar = {
        $0.clear()
        $0.items = [.flexible, keyboardButton, doneButton]
        $0.sizeToFit()
        return $0
    } (UIToolbar(frame: .init(x: 0, y: 0, width: 320, height: 44)))
    
    private var doneButton: UIBarButtonItem {
        UIBarButtonItem(image: UIImage(systemName: XIcon.Icon.power.systemName), style: .done, target: self, action: #selector(doneDidTap))
    }
    
    private var keyboardButton: UIBarButtonItem {
        UIBarButtonItem(image: UIImage(systemName: XIcon.Icon.textformat_alt.systemName), style: .done, target: self, action: #selector(keyboardDidTap))
    }
    private var guitarButton: UIBarButtonItem {
        UIBarButtonItem(image: UIImage(systemName: XIcon.Icon.function.systemName), style: .done, target: self, action: #selector(guitarDidTap))
    }
    //
    weak var textView: UITextView?
    private lazy var chordInputView = ChordsInputView()
    
    func configure(textView: UITextView) {
        textView.inputAccessoryView = keyboardToolbar
        chordInputView.textView = textView
        self.textView = textView
    }
    
    deinit {
        print("Deinit \(ToolbarInputAccessory.self)")
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
