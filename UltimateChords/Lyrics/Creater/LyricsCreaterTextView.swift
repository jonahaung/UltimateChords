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
        context.coordinator.didCompleteChordBlk = { chord in
            print(chord)
        }
        context.coordinator.didUpdateTextBlk = {
            let font = XFont.body(for: $0)
            uiView.font = font
            uiView.text = ChordProConverter.convert($0)
        }
        uiView.text = context.coordinator.lyric.text
        uiView.font = XFont.body(for: context.coordinator.lyric.text)
        return uiView
    }
    
    func updateUIView(_ uiView: EditableTextView, context: Context) {
        uiView.isEditable = context.coordinator.isEditable
    }
    
    func makeCoordinator() -> LyricsCreaterViewModel {
        return viewModel
    }
}


