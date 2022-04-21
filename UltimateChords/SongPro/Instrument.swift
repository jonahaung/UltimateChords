//
//  Instrument.swift
//  
//
//  Created by Aung Ko Min on 12/12/2021.
//

import Foundation


struct Instrument: Decodable, Hashable {
    
    let name: String
    let keys: [String]
    let suffixes: [String]
    let chords: [String: [Instrument.Chord]]
}




extension Instrument {
    static let guitar = instrument(from: "guitar")
    static let ukulele = instrument(from: "ukulele")
    
    func findChordPositions(key: String, suffix: String) -> [Chord.Position] {
        chords[key]?.first(where: { $0.suffix == suffix })?.positions ?? []
    }
    
    static func instrument(from resource: String) -> Instrument {
#if SWIFT_PACKAGE
        let url = Bundle.module.url(forResource: resource, withExtension: "json")
#else
        let url = Bundle.main.url(forResource: resource, withExtension: "json")
#endif
        let data = try! Data(contentsOf: url!)
        return try! JSONDecoder().decode(Instrument.self, from: data)
    }
    
    
}

extension Instrument {
    
    struct Chord: Hashable, Equatable, Decodable {
        let key: String
        let suffix: String
        let positions: [Position]
        
        public struct Position: Hashable, Equatable, Decodable {
            let baseFret: Int
            let barres: [Int]
            let frets: [Int]
            let fingers: [Int]
        }
        static func allChords() -> [Instrument.Chord] {
            var chords = [Instrument.Chord]()
            let guitar = Instrument.guitar
            
            guitar.keys.forEach { key in
                guitar.suffixes.forEach { suff in
                    if let chord = Instrument.Chord.chord(for: key+suff) {
                        if chords.contains(chord) == false {
                            chords.append(chord)
                        }
                    }
                    
                }
            }
            return chords
        }
        
        static func chord(for chordString: String) -> Instrument.Chord? {
            
            var key: String?
            var suffix: String?
            
            if let match = RegularExpression.chordPattern3.firstMatch(in: chordString, options: [], range: chordString.nsRange()) {
                if let keyRange = Range(match.range(at: 1), in: chordString) {
                    var valueKey = chordString[keyRange]
                    /// Dirty, some chords in the database are only in the flat version....
                    if valueKey == "G#" {
                        valueKey = "Ab"
                    }
                    key = String(valueKey)
                }
                if let valueRange = Range(match.range(at: 2), in: chordString) {
                    /// ChordPro suffix are not always the suffixes in the database...
                    var suffixString = "major"
                    switch chordString[valueRange] {
                    case "m":
                        suffixString = "minor"
                    default:
                        suffixString = String(chordString[valueRange])
                    }
                    suffix = suffixString
                }
            }
            guard let key = key, let suffix = suffix else {
                return nil
            }
            let chord = Instrument.Chord(key: key, suffix: suffix, positions: [])
            
            return chord
        }
    }
}
