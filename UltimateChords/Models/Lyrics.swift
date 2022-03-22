//
//  Song.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 17/3/22.
//

import Foundation
import UIKit

struct Lyrics {
    
    let id: String
    var title: String
    var artist: String
    var text: String
    let isMyanmar: Bool
    
    init(id: String = UUID().uuidString, title: String, artist: String, text: String) {
        self.id = id
        self.title = title
        self.artist = artist
        self.text = text
        self.isMyanmar = title.language == "my"
    }
    
    init(cLyrics: CLyrics) {
        self.init(id: cLyrics.id!, title: cLyrics.title ?? "", artist: cLyrics.artist ?? "", text: cLyrics.text ?? "")
    }
    
    func titleFont() -> UIFont {
        return isMyanmar ? XFont.mmUiFont(name: .MyanmarSquare, .Label) : XFont.uiFont(weight: .SemiBold, .Label)
    }
    func textFont() -> UIFont {
        return isMyanmar ? XFont.mmUiFont(.System) : XFont.uiFont(weight: .Medium, .Label)
    }
    func artistFont() -> UIFont {
        return artist.language == "my" ? XFont.mmUiFont(name: .MyanmarSansPro, .Small) : XFont.uiFont(weight: .Medium, .Small)
    }
}

extension Lyrics: ChordDetection {
    
    func lyricsTags() -> LyricsTags {
        detectChord(from: text)
    }
    
}
extension Lyrics: Identifiable {
    
}
