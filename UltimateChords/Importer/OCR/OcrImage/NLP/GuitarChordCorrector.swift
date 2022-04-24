//
//  Syllables.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 19/4/22.
//

import Foundation

struct GuitarChordCorrector {
    
    static let guitarChords: [String] = Chord.allChords().map{$0.name}
    
    static func correctedChordLine(_ line: String) -> String {
        var correctedLine = String.makeEmptyString(for: line.utf16.count)
        line.wordTags().forEach { tag in
            let text = tag.string
            let range = tag.range
            
            if let swiftRange = Range(range, in: line) {
                if GuitarChordCorrector.guitarChords.contains(text) {
                    correctedLine = correctedLine.replacingCharacters(in: swiftRange, with: text)
                } else {
                    correctedLine = correctedLine.replacingCharacters(in: swiftRange, with: String.makeEmptyString(for: text.utf16.count))
                }
            }
        }
        return correctedLine
    }
}

