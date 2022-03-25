//
//  LyricsCreaterTextView.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 22/3/22.
//

import SwiftUI

struct LyricsCreaterTextView: UIViewRepresentable {
    
    @EnvironmentObject var viewModel: LyricsCreaterViewModel
    
    func makeUIView(context: Context) -> WidthFittingTextView {
        let uiView = WidthFittingTextView()
        uiView.typingAttributes = [.font: XFont.body(for: context.coordinator.lyrics.title), .paragraphStyle: NSParagraphStyle.nonLineBreak]
        uiView.isEditable = true
        uiView.isSelectable = true
        uiView.isDinamicFontSizeEnabled = false
        uiView.widthFittingTextViewDelegate = context.coordinator
        uiView.attributedText = context.coordinator.lyrics.displayText
        return uiView
    }
    
    func updateUIView(_ uiView: WidthFittingTextView, context: Context) {
        
    }
    
    func makeCoordinator() -> LyricsCreaterViewModel {
        return viewModel
    }
}

