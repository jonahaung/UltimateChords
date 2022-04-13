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
        
        uiView.keyboardDismissMode = .interactive
        uiView.delegate2 = context.coordinator
        uiView.delegate = context.coordinator
        uiView.setTupEditing()
        return uiView
    }
    
    func updateUIView(_ uiView: EditableTextView, context: Context) {
        uiView.font = XFont.footnote(for: context.coordinator.lyric.text)
        uiView.text = context.coordinator.lyric.text
    }
    
    func makeCoordinator() -> LyricsCreaterViewModel {
        return viewModel
    }
}


