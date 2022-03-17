//
//  Song.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 17/3/22.
//

import Foundation

struct Song {
    let id = UUID().uuidString
    let title: String
    let artist: [String]
    let lyrics: String
}

extension Song: Identifiable {
    
}
