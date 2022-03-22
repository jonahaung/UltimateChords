//
//  LyricsCreaterViewModel.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 22/3/22.
//

import UIKit

final class LyricsCreaterViewModel: NSObject, ObservableObject {
    
    @Published var lyrics = Lyrics(title: "", artist: "", text: "")
    @Published var canInputLyrics = false
    
    func isValidArtist() -> Bool {
        !lyrics.artist.isEmpty && !lyrics.artist.isEmpty
    }
    
    func save() {
        CLyrics.create(lyrics: self.lyrics)
    }
}

extension LyricsCreaterViewModel: WidthFittingTextViewDelegate {
    func textViewDidChange(_ textView: WidthFittingTextView) {
        self.lyrics.text = textView.text
    }
}
