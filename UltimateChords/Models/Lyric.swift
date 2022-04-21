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
    var key: String
    var composer: String
    var album: String
    var year: String
    var text: String
    var version: Int
    var genre: String
    
    init(id: String?, title: String, artist: String, key: String = "", text: String, composer: String = "", album: String = "", year: String = "", genre: String = "", version: Int = 0) {
        self.id = id ?? UUID().uuidString
        self.title = title
        self.artist = artist
        self.key = key
        self.text = text
        self.composer = composer
        self.version = version
        self.year = year
        self.album = album
        self.genre = genre
    }
    
    var canSave: Bool {
        !title.isEmpty && !artist.isEmpty && !text.isEmpty
    }
    
    static let empty = Lyric(id: UUID().uuidString, title: "", artist: "", text: "")
}


