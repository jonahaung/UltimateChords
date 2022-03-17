//
//  LyricsTextVeiw.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 17/3/22.
//

import SwiftUI

internal class LyricsInternalTextView: UITextView {
    
    init() {
        super.init(frame: .zero, textContainer: nil)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    var fontSize: CGFloat {
        get {
            return font?.pointSize ?? 0
        }
        set {
            font = self.font?.withSize(newValue)
        }
    }
}

struct LyricsTextView: UIViewRepresentable {
    
    @EnvironmentObject var tagsControl: LyricsTextViewCoordinator
    
    func makeUIView(context: Context) -> LyricsInternalTextView {
        let uiView = LyricsInternalTextView()
        uiView.attributedText = context.coordinator.attributedText
        return uiView
    }
    
    func updateUIView(_ uiView: LyricsInternalTextView, context: Context) {
        uiView.isEditable = context.coordinator.isEditable
        uiView.attributedText = context.coordinator.attributedText
    }
    
    func makeCoordinator() -> LyricsTextViewCoordinator {
        return tagsControl
    }
}
