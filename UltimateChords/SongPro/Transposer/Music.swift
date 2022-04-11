//
//  Music.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 10/4/22.
//

import Foundation
extension Array where Element == MusicNote {
    var string: String {
        return self.map{$0.name}.joined(separator: " ")
    }
}


public class Music {
    static let scalePatterns = ["major" : [0, 2, 4, 5, 7, 9, 11, 12]]
    public static let noteNames = [     ["C","B#"],
                            ["C#", "Db"],
                            ["D"],
                            ["D#", "Eb"],
                            ["E", "Fb"],
                            ["F", "E#"],
                            ["F#", "Gb"],
                            ["G"],
                            ["G#", "Ab"],
                            ["A"],
                            ["A#", "Bb"],
                            ["B", "Cb"]
    ]
    public static let allNotes = noteNames.joined().joined(separator: " ").split(separator: " ").map{String($0)}
    enum Accidental: Int {
        case sharp = 1
        case flat = -1
        case natural = 0
    }
    static let accidentalSymbols: [Character : Music.Accidental] = ["#" :
        .sharp, "b" : .flat]
    
    static let circleOfFifths = allMajorKeys.sorted { return $0.value < $1.value }
    static let circleOfFifthsNames = circleOfFifths.map {$0.name!.split(separator: " ")[0]}.joined(separator: " ")
    static let orderOfAccidentals = Music.circleOfFifths.map { Music.newAcc3(in: $0) }
    
    static let allMajorKeys = getAllMajorKeys()
    class func getAllMajorKeys() -> [MusicKey] {
        let allNotes = Music.noteNames.joined().joined(separator: " ").split(separator: " ")
        var allMajorKeys = [MusicKey]()
        for note in allNotes {
            if let key = MusicKey(note+" major") { allMajorKeys.append(key) }
        }
        return allMajorKeys
    }
    
    
    class func newAcc3(in key: MusicKey) -> MusicNote? {
        // get comparison key by comparing values
        guard key.value != 0 else { return nil }
        guard let prevKey = allMajorKeys.first(where: { $0.value == key.value + (key.value < 0 ? 1 : -1 )})
            else { return nil }
        
        return key.keySig.first(where:) { !prevKey.keySig.contains($0) } ?? nil
    }
        
    
}
