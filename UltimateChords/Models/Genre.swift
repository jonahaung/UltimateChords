//
//  Genre.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 21/4/22.
//

import Foundation

enum Genre: String, Identifiable, CaseIterable, CustomStringConvertible {
    
    case Pop, Hip_Hop, Rock, Rythm_and_blues, Soul, Reggae, Country, Funk, Folk, Middle_Eastern, Jazz, Disco, Classical, Electronic, Blues, Latin_America, Music_for_children, New_age, Vocal, Africa, Christian, Asia, Ska, Traditional, Independent, Other
    
    var description: String { rawValue.replacingOccurrences(of: "_", with: " ")}
    var id: String { rawValue }
}
