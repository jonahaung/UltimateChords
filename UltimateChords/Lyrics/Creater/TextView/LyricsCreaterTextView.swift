//
//  LyricsCreaterTextView.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 22/3/22.
//

import SwiftUI

struct LyricsCreaterTextView: UIViewRepresentable {
    
    let viewModel: LyricsCreaterViewModel
    
    func makeUIView(context: Context) -> EditableTextView {
        let uiView = EditableTextView()
        uiView.configureToolbar()
        uiView.delegate = viewModel
        viewModel.textView = uiView
        return uiView
    }
    
    func updateUIView(_ uiView: EditableTextView, context: Context) {}
}
