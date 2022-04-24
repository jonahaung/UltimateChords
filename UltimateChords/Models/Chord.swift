// MARK: - struct: the chords in the song

import Foundation
import SwiftyChords

struct Chord: Identifiable, Equatable {
    
    var id: String { name }
    var name: String
    var key: Chords.Key
    var suffix: Chords.Suffix
    var define: String
    var basefret: Int {
        return Int(define.prefix(1)) ?? 1
    }
    
    static func chord(for chordString: String) -> Chord? {
        
        var key: Chords.Key?
        var suffix: Chords.Suffix = .major
        
        if let match = RegularExpression.chordPatternBeginning.firstMatch(in: chordString, options: [], range: chordString.nsRange()) {
            if let keyRange = Range(match.range(at: 1), in: chordString) {
                var valueKey = chordString[keyRange]
                /// Dirty, some chords in the database are only in the flat version....
                if valueKey == "G#" {
                    valueKey = "Ab"
                }
                key = Chords.Key(rawValue: String(valueKey)) ?? Chords.Key.c
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
                suffix = Chords.Suffix(rawValue: suffixString) ?? Chords.Suffix.major
            } else {
                suffix = Chords.Suffix.major
            }
        }
        guard let key = key else {
            return nil
        }

        let name = key.rawValue + (suffix == .major ? String() : suffix == .minor ? "m" : suffix.rawValue)
        let chord = Chord(name: name, key: key, suffix: suffix, define: "")
        
        return chord
    }
    
    static func allChords() -> [Chord] {
        var chords = [Chord]()
        let guitar = Instrument.guitar
        
       guitar.keys.forEach { key in
           guitar.suffixes.forEach { suff in
               if let chord = Chord.chord(for: key+suff) {
                   if chords.contains(chord) == false {
                       chords.append(chord)
                   }
               }
               
           }
        }
        return chords
    }
}
