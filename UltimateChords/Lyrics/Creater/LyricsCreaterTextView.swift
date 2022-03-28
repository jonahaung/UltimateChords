//
//  LyricsCreaterTextView.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 22/3/22.
//

import SwiftUI

struct LyricsCreaterTextView: UIViewRepresentable {
    
    @EnvironmentObject var viewModel: LyricsCreaterViewModel
    
    func makeUIView(context: Context) -> EditableTextView {
        let uiView = EditableTextView()
        uiView.typingAttributes = [.font: XFont.body(for: context.coordinator.lyrics.title), .paragraphStyle: NSParagraphStyle.nonLineBreak]
        uiView.isEditable = false
        uiView.isSelectable = true
        uiView.attributedText = context.coordinator.lyrics.text.lyricAttrString()
        uiView.keyboardDismissMode = .interactive
        uiView.delegate = context.coordinator
        uiView.setTupEditing()
        return uiView
    }
    
    func updateUIView(_ uiView: EditableTextView, context: Context) {
        
    }
    
    func makeCoordinator() -> LyricsCreaterViewModel {
        return viewModel
    }
}


