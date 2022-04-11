//
//  Song.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 17/3/22.
//

import Foundation

struct Lyric: Identifiable {
    
    let id: String
    var title: String
    var artist: String
    var text: String
    
    init(id: String = UUID().uuidString, title: String, artist: String, text: String) {
        self.id = id
        self.title = title
        self.artist = artist
        self.text = text
    }

}


