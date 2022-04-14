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
        
        uiView.delegate = context.coordinator
        uiView.setupToolbar()
        
        return uiView
    }
    
    func updateUIView(_ uiView: EditableTextView, context: Context) {
        if uiView.text != context.coordinator.lyric.text {
            uiView.attributedText = NSAttributedString(context.coordinator.lyric.text)
            uiView.textDidChange()
        }
    }
    
    func makeCoordinator() -> LyricsCreaterViewModel {
        return viewModel
    }
}
