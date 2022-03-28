//
//  LyricsViewerViewModel.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 18/3/22.
//

import UIKit

class LyricsViewerViewModel: NSObject, ObservableObject {
    
    enum ViewType: Identifiable {
        var id: ViewType {self}
        case Pdf, Html, Text
    }
    
    enum DisplayMode {
        case Default, Editing, TextOnly
    }
    
    @Published var displayMode = DisplayMode.Default
    @Published var zoom: Double = 1.0
    @Published var viewType: ViewType?
    @Published var adjustFontSize = false
    
    let lyrics: Lyrics
    @Published var song: Song?
    
    init(_ lyrics: Lyrics) {
        self.lyrics = lyrics
        super.init()
    }
}

extension LyricsViewerViewModel {
    
    func loadSong() async {
       let song = ChordPro.parse(string: lyrics.text)
        
        song.title = lyrics.title
        song.artist = lyrics.artist
        DispatchQueue.main.async {
            self.song = song
        }
    }
    
    
    var displayText: NSAttributedString {
        switch displayMode {
        case .Default:
            return song?.attributedText ?? .init()
        case .Editing:
            return lyrics.chordProText()
        case .TextOnly:
            return lyrics.text.lyricAttrString()
        }
    }
    
    func toggleSelect() {
        switch displayMode {
        case .Default:
            displayMode = .Editing
        case .Editing:
            displayMode = .TextOnly
        case .TextOnly:
            displayMode = .Default
        }
        objectWillChange.send()
    }
}
