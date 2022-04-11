//
//  PlainTextParser.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 10/4/22.
//

import Foundation

struct ChordProConverter {
    
    private static func isChordLine(line: String) -> Bool {
        RegularExpression.chordsRegexForPlainText.matches(in: line, range: line.range()).isEmpty == false
    }
    
    private static func nextLine(from index: Int, lines: [String]) -> String? {
        guard index+1 < lines.count else { return nil }
        return lines[index+1]
    }
    
    static func getCLTags(from text: String) -> [ChordTag] {
        var results = [ChordTag]()
        RegularExpression.chordsRegexForPlainText.matches(in: text, range: text.range()).forEach { match in
            let subRange = match.range
            let subStr = (text as NSString).substring(with: subRange)
            let chordTag = ChordTag(chord: String(subStr), range: subRange)
            results.append(chordTag)
        }
        return results
    }
    
    private static func concentrate(chordLine: inout String, lyricLine: inout String) -> String {
        
        func firstMatch(of string: String) -> ChordTag? {
            if let match = RegularExpression.chordsRegexForPlainText.firstMatch(in: string, range: string.range()) {
                let subRange = match.range
                let subStr = (string as NSString).substring(with: subRange)
                return ChordTag(chord: String(subStr), range: subRange)
            }
            return nil
        }
        
        while chordLine.utf16.count < lyricLine.utf16.count {
            chordLine += " "
        }
        while lyricLine.utf16.count < chordLine.utf16.count {
            lyricLine += " "
        }
        
        let mutableChordLine = NSMutableString(string: chordLine)
        let mutableLyricLine = NSMutableString(string: lyricLine)
        
        while let tag = firstMatch(of: String(mutableChordLine)) {
            let chord = "[\(tag.chord.trimmed())]"
            mutableChordLine.replaceCharacters(in: tag.range, with: makeEmptyString(for: tag.range.length + 2))
            mutableLyricLine.insert(chord, at: tag.range.location - (tag.range.location == 0 ? 0 : 1))
        }
        return String(mutableLyricLine)
    }
    
    private static func makeEmptyString(for i: Int) -> String {
        var str = String()
        (0...i).forEach { _ in
            str += "-"
        }
        return str
    }
    
    static func convert(_ text: String) -> String {
        
        let textLines = text.components(separatedBy: "\n")
        
        var newLines = [String]()
        
        for (var i, textLine) in textLines.enumerated() {
            if isChordLine(line: textLine) {
                
                var chordLine = textLine
                
                if let nextLine = nextLine(from: i, lines: textLines), isChordLine(line: nextLine) == false  {
                    
                    var lyricLine = nextLine
                    
                    let concenerated = concentrate(chordLine: &chordLine, lyricLine: &lyricLine)
                    newLines.append(concenerated)
                    i += 1
                } else {
                    newLines.append(textLine)
                }
            } else {
                newLines.append(textLine)
            }
        }
        return newLines.joined(separator: "\n")
    }
}
