//
//  LyricViewerService.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 5/4/22.
//

import Foundation

class LyricViewerService {
    
    @Published var song: Song?
    
    func configure(lyric: Lyric) async {
        self.song = lyric.song()
    }
    
    
}
