//
//  LyricViewerService.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 5/4/22.
//

import Foundation

class LyricViewerService {
    
    var song: Song?
    @Published var attributedText: NSAttributedString?
    
    @Published var displayMode = DisplayMode.Default
}

extension LyricViewerService {
    
    func configure(lyric: Lyric) async {
        self.song = lyric.song()
        self.attributedText = AttributedString.displayText(for: song!, with: displayMode)
    }
    
    func setDisplayMode(_ newValue: DisplayMode) {
        self.displayMode = newValue
        guard let song = self.song else { return }
        self.attributedText = AttributedString.displayText(for: song, with: newValue)
    }
}


extension LyricViewerService {
    enum DisplayMode: String, CaseIterable {
        case Default, Copyable, Editing, TextOnly
    }
}
