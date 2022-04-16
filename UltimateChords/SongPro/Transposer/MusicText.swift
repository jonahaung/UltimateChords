//
//  MusicText.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 10/4/22.
//

import Foundation
struct MusicText {
    enum IsMusic: Int {
        case defNot = 0, probNot, maybe, probably, definitely
    }
    
    static let probSymbols = ["|", "%", "...", "…", "||:", ":||", "||", "[", "]"]
    static let maybeContainsSymbols = [","]
    static let probContainsSymbols = ["...", "…", "#"]
    static let formTitles = ["Verse", "Chorus", "Intro", "Bridge", "Interlude"]
    static let formSeparators = [":"]
    static let defNotContainsSymbols = ["!", "?", "$"]
    static let maybeContainsBothSymbols = ["()"]
    static let numbers = [1,2,3,4,5,6,7,8,9,0].map{String($0)}
    
    static let separators = maybeContainsSymbols + probContainsSymbols
    
    static let componentScores: [(strings: [String], isPart: IsMusic)] = [
        (probSymbols, .probably)
    ]
    static let containsScores: [(strings: [String], isPart: IsMusic)] = [
        (maybeContainsSymbols, .maybe),
        (probContainsSymbols, .probably),
        (numbers, .probably),
        (defNotContainsSymbols, .defNot),
        (formTitles, .defNot),
    ]
    static let containsBothScores: [(strings: [String], isPart: IsMusic)] = [
        (maybeContainsBothSymbols, .maybe),
    ]
    
    static func evaluateComponentSymbols(in string: String) -> MusicText.IsMusic? {
        // if this is only a symbol, that might tell us something
        return MusicText.componentScores.first(where:) {$0.strings.contains(string)}?.isPart
    }
    
    static func evaluateContainsSymbols(in sourceString: String) -> MusicText.IsMusic? {
        // if it contains one of these symbols, that effects its likeliness to be music
        for textType in MusicText.containsScores {
            // Refactoring note:
            // In "return textType.first(where:){string.contains(XXXX)}?.isPart", XXXX would have to be "one of the elements in the array"
            for string in textType.strings {
                if sourceString.contains(string) { return textType.isPart }
            }
        }
        return nil
    }
    
    static func evaluateBothSymbols(in string: String) -> MusicText.IsMusic? {
        // if it contains both of these symbols, but isn't wrapped in them (which would cancel out their effect here), that effects its score
        for textType in MusicText.containsBothScores {
            for string in textType.strings {
                if string.contains(string.first!) && string.contains(string.last!)
                    && !(string.first == string.first && string.last == string.last) {
                    return textType.isPart
                }
            }
        }
        return nil
    }
    
}

extension String {
    var isMusic: MusicText.IsMusic {
        var heartStr = self
        removeLeadingOrTrailingParens(from: &heartStr)
        if let score = MusicText.evaluateComponentSymbols(in: heartStr) { return score }
        if MusicChord(heartStr) == nil { return .defNot }
        
        if let score = MusicText.evaluateContainsSymbols(in: self) { return score }
        if let score = MusicText.evaluateBothSymbols(in: self) { return score }
        
        return .maybe
    }
    
    var looksLikeMusic: Bool {
        switch self.isMusic {
        case .defNot, .probNot: return false
        default: return true
        }
    }
    
    var isMusicLine_byCount: Bool {
        let nonChordMinimum = 3
        let components = self.split(separator: " ").map{String($0)}
        let nonChords = components.filter {!$0.looksLikeMusic}
        return !(nonChords.count >= nonChordMinimum)
    }
    
    func removeLeadingOrTrailingParens(from string: inout String) {
        // remove any leading and/or trailing parens
        if string.count > 1 {
            for textType in MusicText.containsBothScores {
                for sym in textType.strings {
                    if string.first == sym.first { string.removeFirst() }
                    if string.last == sym.last { string.removeLast() }
                }
            }
        }
    }
    
}
