//
//  MusicNote.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 10/4/22.
//

import Foundation
class MusicNote: Equatable, CustomStringConvertible {
    /* TO-DO:
     // 2. make name and num lazy so we don't have to compute each one every time a note is created (sometimes we don't need both)
     */
    
    var name: String
    var num: Int
    
    class func getNumWithinOctave(num: Int) -> Int {
        var adjNum = num
        while adjNum < 0 { adjNum += 12 }
        while adjNum >= 12 { adjNum -= 12 }
        return adjNum
    }
    
    init? (_ name: String) {
        self.num = -1
        for (index, names) in Music.noteNames.enumerated() {
            if names.firstIndex(of: name) != nil {
                self.num = index
            }
        }
        if self.num == -1 {
            return nil
        } else {
            self.name = name
        }
    }
    
    init (_ num: Int) {
        self.num = num
        let adjNum = MusicNote.getNumWithinOctave(num: num)
        self.name = Music.noteNames[adjNum].first!
    }
    
    static func == (_ ls: MusicNote, _ rs: MusicNote) -> Bool {
        return ls.name == rs.name
    }
    
    lazy var isSharp = self.name.contains("#")
    
    lazy var isFlat = self.name.contains("b")
    
    lazy var description = "Note (name: \(self.name), num: \(self.num))"
    
    func transpose(_ steps: Int) -> MusicNote {
        var num = self.num + steps
        num = MusicNote.getNumWithinOctave(num: num)
        return MusicNote(num)
    }
}

extension MusicNote {
    // complex transposing
    
    fileprivate func preferredSpelling(in destKey: MusicKey, from possibleNames: [String]) -> MusicNote {
        let keyPos = Music.circleOfFifths.firstIndex(of: destKey)!
        let notePreferences = possibleNames.map { (noteName) -> Int in
            var distance = 0
            if let notePos = Music.orderOfAccidentals.firstIndex(of: MusicNote(noteName)!) {
                distance = abs(keyPos - notePos)
                return min(distance, notePos) // A note that occurs earlier in the circle of 5ths is probably preferable to a note closerby.
                // TO-DO: When the notePreferences are equal because one is distance and one is notePos, prefer the one returning distance.
            } else {
                // TO-DO: note isn't an accidental. what do we do?
            }
            return distance
        }
        let closest = min(notePreferences[0], notePreferences[1])
        let closestIndex = notePreferences.firstIndex(of: closest)!
        let closestNoteName = possibleNames[closestIndex]
        
        return MusicNote(closestNoteName)!
    }
    
    func transpose(from sourceKey: MusicKey, to destKey: MusicKey) -> MusicNote {
        // note diatonic to source key, using degrees
        if let degree = sourceKey.notes.firstIndex(of: self) { return destKey[degree] }
        
        // note not diatonic to source key, using intervals
        let tonic = sourceKey[0]
        
        // SHIT! All tests passed because we were in C.
        let interval = MusicNote.getNumWithinOctave(num: self.num - tonic.num)
        let newNote = destKey[0].transpose(interval) // this new note is initialized with the first possible name.
        
        let possibleNames = Music.noteNames[newNote.num]
        if possibleNames.count == 1 {
            return newNote
        } else {
            // lots of unwrapped optionals here. as long as we're in the testing phase they should just serve to uncover bugs
            let noteNameBase = self.name.first!
            let degree = sourceKey.notes.firstIndex(of: sourceKey.notes.first(where:) { $0.name.first! == noteNameBase }!)!
            let destBaseNote = destKey[degree]
            if let destBaseLetter = Music.noteNames[newNote.num].first(where: { $0.first! == destBaseNote.name.first! }) {
                return MusicNote(destBaseLetter)!
            } else {
                return newNote
            }
        }
    }
    
}
