//
//  LyricsViewerTextView.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 18/3/22.
//

import SwiftUI

struct LyricsViewerTextView: UIViewRepresentable {
    
    @EnvironmentObject var viewModel: LyricsViewerViewModel
    
    func makeUIView(context: Context) -> WidthFittingTextView {
        let uiView = WidthFittingTextView($viewModel.isDinamicFontSizeEnabled)
        uiView.isEditable = false
        uiView.isScrollEnabled = false
        return uiView
    }
    
    func updateUIView(_ uiView: WidthFittingTextView, context: Context) {
        uiView.attributedText = context.coordinator.attributedText
        uiView.setNeedsLayout()
    }
    
    func makeCoordinator() -> LyricsViewerViewModel {
        return viewModel
    }
}
