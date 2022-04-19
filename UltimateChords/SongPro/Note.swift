//
//  Note.swift
//  Transposer
//
//  Created by Jonathan Tuzman on 5/7/18.
//  Copyright © 2018 Jonathan Tuzman. All rights reserved.
//

import Foundation

class Note: Equatable {
    
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
        for (index, names) in Note.noteNames.enumerated() {
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
        let adjNum = Note.getNumWithinOctave(num: num)
        self.name = Note.noteNames[adjNum].first!
    }
    
    lazy var isSharp = self.name.contains("#")
    
    lazy var isFlat = self.name.contains("b")
    
    func transpose(_ steps: Int) -> Note {
        var num = self.num + steps
        num = Note.getNumWithinOctave(num: num)
        return Note(num)
    }
    
    static func == (_ ls: Note, _ rs: Note) -> Bool {
        return ls.name == rs.name
    }
}


extension Note {
    
    func transpose(from sourceKey: Key, to destKey: Key) -> Note {
        // note diatonic to source key, using degrees
        if let degree = sourceKey.notes.firstIndex(of: self) { return destKey[degree] }
        
        // note not diatonic to source key, using intervals
        let tonic = sourceKey[0]
        
        // SHIT! All tests passed because we were in C.
        let interval = Note.getNumWithinOctave(num: self.num - tonic.num)
        let newNote = destKey[0].transpose(interval) // this new note is initialized with the first possible name.
        
        let possibleNames = Note.noteNames[newNote.num]
        if possibleNames.count == 1 {
            return newNote
        } else {
            // lots of unwrapped optionals here. as long as we're in the testing phase they should just serve to uncover bugs
            let noteNameBase = self.name.first!
            let degree = sourceKey.notes.firstIndex(of: sourceKey.notes.first(where:) { $0.name.first! == noteNameBase }!)!
            let destBaseNote = destKey[degree]
            if let destBaseLetter = Note.noteNames[newNote.num].first(where: { $0.first! == destBaseNote.name.first! }) {
                return Note(destBaseLetter)!
            } else {
                return newNote
            }
        }
    }
}

extension Note {
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
                                        ["B", "Cb"]]
    
    enum Accidental: Int {
        case sharp = 1
        case flat = -1
        case natural = 0
    }
    static let accidentalSymbols: [Character : Accidental] = ["#" : .sharp, "b" : .flat]
    static let allNotes = noteNames.joined().joined(separator: " ").split(separator: " ").map{String($0)}
    static let scalePatterns = ["major" : [0, 2, 4, 5, 7, 9, 11, 12]]
    static let orderOfAccidentals = circleOfFifths.map { newAcc3(in: $0) }
    static let circleOfFifths = allMajorKeys.sorted { return $0.value < $1.value }
    
    class func newAcc3(in key: Key) -> Note? {
        // get comparison key by comparing values
        guard key.value != 0 else { return nil }
        guard let prevKey = allMajorKeys.first(where: { $0.value == key.value + (key.value < 0 ? 1 : -1 )})
        else { return nil }
        
        return key.keySig.first(where:) { !prevKey.keySig.contains($0) } ?? nil
    }
    
    static let allMajorKeys = getAllMajorKeys()
    class func getAllMajorKeys() -> [Key] {
        let allNotes = noteNames.joined().joined(separator: " ").split(separator: " ")
        var allMajorKeys = [Key]()
        for note in allNotes {
            if let key = Key(note+" major") { allMajorKeys.append(key) }
        }
        return allMajorKeys
    }
    
}
