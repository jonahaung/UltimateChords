//
//  LyricsViewerTextView.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 18/3/22.
//

import SwiftUI

internal class LyricsViewerInternalTextView: UITextView {
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented")}
    init() {
        super.init(frame: .zero, textContainer: nil)
        setup()
    }
    
    private func setup() {
        isEditable = false
        isSelectable = true
        dataDetectorTypes = []
    }
    
    var fontSize: CGFloat{
        get {
            return font?.pointSize ?? 0
        }
        set {
            guard newValue != fontSize else { return }
            var attributes = attributedText.attributes
            let font = attributes[.font] as? UIFont
            attributes[.font] = font?.withSize(newValue)
            self.attributedText = NSAttributedString(string: text, attributes: attributes)
        }
    }
    
    override var text: String!{
        willSet {
            attributedText = .init(string: newValue, attributes: [.paragraphStyle: NSParagraphStyle.nonLineBreak, .font: self.font!])
        }
    }
}

struct LyricsViewerTextView: UIViewRepresentable {
    
    @EnvironmentObject var viewModel: LyricsViewerViewModel
    
    func makeUIView(context: Context) -> LyricsViewerInternalTextView {
        let uiView = LyricsViewerInternalTextView()
        uiView.font = XFont.uiFont(.SemiBold, .System)
        uiView.textContainer.lineBreakMode = .byClipping
        uiView.showsVerticalScrollIndicator = false
        uiView.text = context.coordinator.getText()
        return uiView
    }
    
    func updateUIView(_ uiView: LyricsViewerInternalTextView, context: Context) {
        uiView.fontSize = context.coordinator.fontSize
    }
    
    func makeCoordinator() -> LyricsViewerViewModel {
        return viewModel
    }
}

