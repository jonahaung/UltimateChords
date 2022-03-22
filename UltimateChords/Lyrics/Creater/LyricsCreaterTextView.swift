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
        uiView.widthFittingTextViewDelegate = context.coordinator
        return uiView
    }
    
    func updateUIView(_ uiView: WidthFittingTextView, context: Context) {
        
    }
    
    func makeCoordinator() -> LyricsCreaterViewModel {
        return viewModel
    }
}

