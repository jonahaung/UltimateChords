//
//  LyricsViewerViewModel.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 18/3/22.
//

import UIKit

class LyricsViewerViewModel: NSObject, ObservableObject {
    
    let lyrics: Lyrics
    @Published var pdfData: Data?
    @Published var song: Song?
    
    init(_ lyrics: Lyrics) {
        self.lyrics = lyrics
        super.init()
    }
}

extension LyricsViewerViewModel {
    
    func makePDF() {
        self.pdfData = lyrics.pdfData()
    }
    func makeHtml() {
        self.song = ChordPro.parse(string: lyrics.text)
    }
    func toggleSelect() {
        switch lyrics.displayMode {
        case .Default:
            lyrics.displayMode = .Editing
        case .Editing:
            lyrics.displayMode = .TextOnly
        case .TextOnly:
            lyrics.displayMode = .Default
        }
        objectWillChange.send()
    }
}
