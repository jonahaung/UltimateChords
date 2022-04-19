//
//  Song.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 17/3/22.
//

import Foundation

struct Lyric: Identifiable {
    
    var id: String
    var title: String
    var artist: String
    var text: String
    var version: Int
    
    init(id: String?, title: String, artist: String, text: String, version: Int = 0) {
        self.id = id ?? UUID().uuidString
        self.title = title
        self.artist = artist
        self.text = text
        self.version = version
    }
}


