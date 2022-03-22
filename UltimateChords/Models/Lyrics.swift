//
//  Song.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 17/3/22.
//

import Foundation

struct Lyrics {
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
    init(cLyrics: CLyrics) {
        self.init(id: cLyrics.id ?? UUID().uuidString, title: cLyrics.title ?? "", artist: cLyrics.artist ?? "", text: cLyrics.text ?? "")
    }
}

extension Lyrics: Identifiable {
    
}
