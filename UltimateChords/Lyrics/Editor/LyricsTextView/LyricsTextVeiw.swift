//
//  LyricsTextVeiw.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 17/3/22.
//

import SwiftUI

internal class LyricsInternalTextView: UITextView {
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented")}
    init() {
        super.init(frame: .zero, textContainer: nil)
        setup()
    }
    
    private func setup() {
        dataDetectorTypes = []
    }
    
    override var isEditable: Bool {
        didSet {
            if isEditable {
                becomeFirstResponder()
                selectedTextRange = self.textRange(from: self.endOfDocument, to: endOfDocument)
            }
        }
    }

    func setTags(tags: [DPTag]) {
        let attributedString = NSMutableAttributedString(attributedString: attributedText)
        tags.forEach { (dpTag) in
            attributedString.addAttributes(dpTag.customTextAttributes, range: dpTag.range)
        }
        attributedText = attributedString
    }
}

struct LyricsTextView: UIViewRepresentable {
    
    @EnvironmentObject var tagsControl: LyricsTextViewCoordinator
    
    func makeUIView(context: Context) -> LyricsInternalTextView {
        let uiView = LyricsInternalTextView()
        uiView.attributedText = context.coordinator.attributedText
        uiView.delegate = context.coordinator

        context.coordinator.setTagsBlock = { [weak uiView] tags in
            uiView?.setTags(tags: tags)
        }
        context.coordinator.setAttributedTextBlock = { [weak uiView] attributedText in
            uiView?.attributedText = attributedText
        }
        return uiView
    }
    
    func updateUIView(_ uiView: LyricsInternalTextView, context: Context) {
        uiView.isEditable = context.coordinator.isEditable
    }
    
    func makeCoordinator() -> LyricsTextViewCoordinator {
        return tagsControl
    }
}
