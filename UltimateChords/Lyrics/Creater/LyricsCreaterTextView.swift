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
        uiView.delegagte2 = context.coordinator
        uiView.delegate = context.coordinator
        uiView.setTupEditing()
        context.coordinator.didCompleteChordBlk = {
            uiView.addChord(chord: $0)
        }
        context.coordinator.didUpdateTextBlk = {
            uiView.text = $0
            
            let font = XFont.body(for: $0)
            uiView.typingAttributes = [.font: font]
            uiView.font = font
            
        }
        return uiView
    }
    
    func updateUIView(_ uiView: EditableTextView, context: Context) {
        uiView.isEditable = context.coordinator.isEditable
        uiView.isChordMode = context.coordinator.isChordMode
    }
    
    func makeCoordinator() -> LyricsCreaterViewModel {
        return viewModel
    }
}


