//
//  LyricsViewerViewModel.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 18/3/22.
//

import UIKit
import SwiftUI

class LyricsViewerViewModel: ObservableObject {
    
    @Published var song: Song?
    @Published var showControls = false
    @Published var activityItem: ActivityItem?
    
    var attributedText: NSAttributedString {
        AttributedString.displayText(for: song, with: displayMode)
    }
    
    var isDinamicFontSizeEnabled: Bool {
        get { UserDefault.LyricViewer.isDinamicFontSizeEnabled }
        set { UserDefault.LyricViewer.isDinamicFontSizeEnabled = newValue; hideControlsIfNeeded() }
    }
    
    var showChords: Bool {
        get { UserDefault.LyricViewer.showChords }
        set { UserDefault.LyricViewer.showChords = newValue; objectWillChange.send(); hideControlsIfNeeded() }
    }
    var displayMode: UserDefault.LyricViewer.DisplayMode {
        get { UserDefault.LyricViewer.displayMode }
        set { UserDefault.LyricViewer.displayMode = newValue; objectWillChange.send(); hideControlsIfNeeded() }
    }
    deinit{
        print("deinit")
    }
}

extension LyricsViewerViewModel {
    
    func configure(_ lyric: Lyric) {
        var song = SongConverter.parse(rawText: lyric.text)
        if song.title == nil {
            song.title = lyric.title
        }
        if song.artist == nil {
            song.artist = lyric.artist
        }
        self.song = song
    }
    
    func hideControlsIfNeeded() {
        if showControls {
            withAnimation(.interactiveSpring()) {
                showControls = false
            }
        }
    }
}

