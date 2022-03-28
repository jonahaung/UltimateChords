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
        uiView.isDinamicFontSizeEnabled = false
        uiView.isEditable = false
        uiView.isSelectable = true
        return uiView
    }
    
    func updateUIView(_ uiView: WidthFittingTextView, context: Context) {
        uiView.attributedText = context.coordinator.displayText
        uiView.fontSizePercent = context.coordinator.zoom
    
    }
    
    func makeCoordinator() -> LyricsViewerViewModel {
        return viewModel
    }
}
