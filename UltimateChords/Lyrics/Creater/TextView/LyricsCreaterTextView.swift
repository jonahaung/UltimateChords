//
//  LyricsCreaterTextView.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 22/3/22.
//

import SwiftUI

struct LyricsCreaterTextView: UIViewRepresentable {
    
    @EnvironmentObject private var viewModel: LyricsCreaterViewModel
    
    func makeUIView(context: Context) -> EditableTextView {
        let textView = EditableTextView()
        textView.configureToolbar()
        textView.bounces = true
        textView.alwaysBounceVertical = true
        textView.text = viewModel.lyric.text
        textView.delegate = viewModel
        viewModel.textView = textView
        textView.detectChords()
        return textView
    }
    
    func updateUIView(_ uiView: EditableTextView, context: Context) {
        uiView.detectChords()
    }
}
