//
//  LyricsViewerViewModel.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 18/3/22.
//

import Foundation

class LyricsViewerViewModel: ObservableObject {
    
    private let lyrics: Lyrics

    init(_ lyrics: Lyrics) {
        self.lyrics = lyrics
    }
    
    func getLyrics() -> Lyrics { lyrics }
    func getText() -> String { lyrics.text }
}
