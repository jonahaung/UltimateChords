//
//  WidthFittingTextView.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 22/3/22.
//

import UIKit

protocol WidthFittingTextViewDelegate: AnyObject {
    func textViewDidChange(_ textView: WidthFittingTextView)
}
class WidthFittingTextView: UITextView {
    
    weak var widthFittingTextViewDelegate: WidthFittingTextViewDelegate?
    
    init() {
        super.init(frame: .zero, textContainer: nil)
        keyboardDismissMode = .interactive
        textContainer.lineFragmentPadding = 5
        showsVerticalScrollIndicator = false
        font = XFont.uiFont(.Medium, .Button)
        typingAttributes = [.font: font!, .paragraphStyle: NSParagraphStyle.nonLineBreak]
        delegate = self
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private var fontSize: CGFloat{
        get {
            return font?.pointSize ?? 0
        }
        set {
            guard newValue != fontSize else { return }
            font = font?.withSize(newValue)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !isEditable {
            adjustFontSize()
        }
    }
    
    private func adjustFontSize() {
        let containerSize = textContainer.size
        let largestSize = CGSize(width: .greatestFiniteMagnitude, height: containerSize.height)
        if isEditable {
            fontSize = UIFont.labelFontSize
        }
        while (containerSize.width - textContainer.lineFragmentPadding - 10) <= attributedText.size(for: largestSize).width {
            fontSize -= 0.5
        }
    }
    
    override func paste(_ sender: Any?) {
        super.paste(sender)
        adjustFontSize()
    }

    override func cut(_ sender: Any?) {
        super.cut(sender)
        adjustFontSize()
    }

    override func insertText(_ text: String) {
        super.insertText(text)
        adjustFontSize()
    }
}

extension WidthFittingTextView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        adjustFontSize()
        widthFittingTextViewDelegate?.textViewDidChange(self)
    }
}
