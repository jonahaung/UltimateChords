//
//  LyricsViewerViewModel.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 18/3/22.
//

import UIKit

class LyricsViewerViewModel: ObservableObject {
    
    @Published var song: Song?
    var isDinamicFontSizeEnabled = UserDefault.isDinamicFontSizeEnabled {
        didSet {
            guard oldValue != isDinamicFontSizeEnabled else { return }
            UserDefault.isDinamicFontSizeEnabled = isDinamicFontSizeEnabled
            objectWillChange.send()
        }
    }
}

extension LyricsViewerViewModel {
    func loadSong(_ lyric: Lyric) async {
        self.song = lyric.song()
    }
}

extension LyricsViewerViewModel: WidthFittingTextViewDelegate {
    
    func textView(textView: WidthFittingTextView, didAdjustFontSize text: NSAttributedString) {
        
    }
}
