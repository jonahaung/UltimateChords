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
        $0.items = [guitarButton, .flexible, cameraButton, doneButton]
        $0.sizeToFit()
        return $0
    } (UIToolbar(frame: .init(x: 0, y: 0, width: 320, height: 44)))
    
    private lazy var cameraToolbar: UIToolbar = {
        $0.clear()
        $0.items = [guitarButton, .flexible, keyboardButton, doneButton]
        $0.sizeToFit()
        return $0
    }(UIToolbar(frame: .init(x: 0, y: 0, width: 320, height: 44)))
    
    private lazy var chordToolbar: UIToolbar = {
        $0.clear()
        $0.items = [.flexible, keyboardButton, doneButton]
        $0.sizeToFit()
        return $0
    } (UIToolbar(frame: .init(x: 0, y: 0, width: 320, height: 44)))
    
    private var doneButton: UIBarButtonItem {
        UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneDidTap))
    }
    private var cameraButton: UIBarButtonItem {
        UIBarButtonItem(image: UIImage(systemName: XIcon.Icon.doc_text_viewfinder.systemName), style: .plain, target: self, action: #selector(cameraDidTap))
    }
    private var keyboardButton: UIBarButtonItem {
        UIBarButtonItem(image: UIImage(systemName: XIcon.Icon.keyboard.systemName), style: .plain, target: self, action: #selector(keyboardDidTap))
    }
    private var guitarButton: UIBarButtonItem {
        UIBarButtonItem(image: UIImage(systemName: XIcon.Icon.music_quarternote_3.systemName), style: .plain, target: self, action: #selector(guitarDidTap))
    }
    //
    weak var textView: UITextView?
    private lazy var cameraInputView = CameraKeyboard()
    private lazy var chordInputView = ChordsInputView()
    
    func configure(textView: UITextView) {
        textView.inputAccessoryView = keyboardToolbar
        cameraInputView.textView = textView
        chordInputView.textView = textView
        self.textView = textView
    }
    
    deinit {
        print("Deinit \(ToolbarInputAccessory.self)")
    }
    
    // Actions
    @objc private func cameraDidTap() {
        textView?.inputAccessoryView = cameraToolbar
        textView?.inputView = cameraInputView
        cameraInputView.startCamera()
        textView?.reloadInputViews()
    }
    
    @objc private func keyboardDidTap() {
        cameraInputView.stopCamera()
        textView?.inputAccessoryView = keyboardToolbar
        textView?.inputView = nil
        textView?.reloadInputViews()
    }
    
    @objc private func guitarDidTap() {
        cameraInputView.stopCamera()
        textView?.inputAccessoryView = chordToolbar
        textView?.inputView = chordInputView
        textView?.reloadInputViews()
    }
    @objc private func doneDidTap() {
        textView?.resignFirstResponder()
//        keyboardDidTap()
    }
}

extension UIBarButtonItem {
    static let flexible = UIBarButtonItem(systemItem: .flexibleSpace)
}

extension UIToolbar {
    
    func clear() {
        setShadowImage(UIImage(), forToolbarPosition: .bottom)
        isTranslucent = false
        tintColor = .label
    }
}
