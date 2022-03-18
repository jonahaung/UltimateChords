//
//  LyricsViewerViewModel.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 18/3/22.
//

import Foundation

class LyricsViewerViewModel: ObservableObject {
    
    let lyrics: Lyrics
    
    @Published var fontSize = XFont.Size.Small.rawValue
    
    init(_ lyrics: Lyrics) {
        self.lyrics = lyrics
    }
    
    func getText() -> String {
        lyrics.text
    }
}
