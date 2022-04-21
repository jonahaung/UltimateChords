//
//  Syllables.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 19/4/22.
//

import UIKit

struct SpellCorrector {
    
    static let myanamrWords: [String] = {
        var items = [String]()
        if let url = Bundle.main.url(forResource: "syllables", withExtension: "txt") {
            do {
                let string = try String(contentsOf: url, encoding: .utf8)
                items = string.words()
            } catch {
                print(error)
            }
        }
        return items
    }()
    
    static let guitarChords: [String] = Chord.allChords().map{$0.name}
    
    static func correctedMyanmarText(_ string: String) -> String {
        var correctedLines = [String]()
        string.lines().forEach { line in
            var words = [String]()
            line.components(separatedBy: " ").forEach { word in
                var correctCharacters = [String]()
                let characters = Resegment.myanmar(word)
                characters.forEach { character in
                    if myanamrWords.contains(character) {
                        correctCharacters.append(character)
                    }
                }
                words.append(correctCharacters.joined())
            }
            correctedLines.append(words.joined(separator: " "))
        }
        return correctedLines.joined(separator: "\n")
    }
    
    static func correctEnglishText(_ string: String) -> String {
        let checker = UITextChecker()
        func isReal(word: String) -> Bool {
            let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: word.nsRange(), startingAt: 0, wrap: false, language: "en")
            return misspelledRange.location == NSNotFound
        }
        
        var correctedLines = [String]()
        string.lines().forEach { line in
            var words = [String]()
            line.components(separatedBy: " ").forEach { word in
                if isReal(word: word) {
                    words.append(word)
                }
            }
            correctedLines.append(words.joined(separator: " "))
        }
        return correctedLines.joined(separator: "\n")
    }
    
    
    
    static func correctedChordLine(_ line: String) -> String {
        var correctedLine = String.makeEmptyString(for: line.utf16.count)
        line.wordTags().forEach { tag in
            let text = tag.string
            let range = tag.range
            
            if let swiftRange = Range(range, in: line) {
                if SpellCorrector.guitarChords.contains(text) {
                    correctedLine = correctedLine.replacingCharacters(in: swiftRange, with: text)
                } else {
                    correctedLine = correctedLine.replacingCharacters(in: swiftRange, with: String.makeEmptyString(for: text.utf16.count))
                }
            }
        }
        return correctedLine
    }
}
