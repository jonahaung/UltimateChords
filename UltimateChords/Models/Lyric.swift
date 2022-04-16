//
//  Song.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 17/3/22.
//

import Foundation

struct Lyric: Identifiable {
    var id = UUID().uuidString
    var title: String
    var artist: String
    var text: String
    
    init(title: String, artist: String, text: String) {
        self.title = title
        self.artist = artist
        self.text = text
    }
}


