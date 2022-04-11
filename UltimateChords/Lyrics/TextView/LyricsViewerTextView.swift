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
        let uiView = WidthFittingTextView()
        uiView.isEditable = false
        uiView.isScrollEnabled = false
        uiView.textContainer.lineBreakMode = .byClipping
        return uiView
    }
    
    func updateUIView(_ uiView: WidthFittingTextView, context: Context) {
        uiView.update(context.coordinator.attributedText, adjustFontSize: context.coordinator.isDinamicFontSizeEnabled)
    }
    
    func makeCoordinator() -> LyricsViewerViewModel {
        return viewModel
    }
}
