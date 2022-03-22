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
        let attributedText = NSAttributedString(string: context.coordinator.getText(), attributes: [.font: XFont.uiFont(.SemiBold, .custom(50)), .paragraphStyle: NSParagraphStyle.nonLineBreak])
        let uiView = WidthFittingTextView()
        uiView.textContainer.lineFragmentPadding = 10
        uiView.isEditable = false
        uiView.isSelectable = true
        uiView.showsVerticalScrollIndicator = false
        uiView.attributedText = attributedText
        return uiView
    }
    
    func updateUIView(_ uiView: WidthFittingTextView, context: Context) {
    }
    
    func makeCoordinator() -> LyricsViewerViewModel {
        return viewModel
    }
}
