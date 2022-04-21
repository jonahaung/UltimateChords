//
//  PlainTextParser.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 10/4/22.
//

import Foundation

struct SongParser {
    
    private static func isChordLine(for line: String) -> Bool {
        if line.words().count == 1 { return true }
        return RegularExpression.chordsRegexForPlainText.matches(in: line, range: line.nsRange()).count > 0
    }
    
    private static func nextLine(from index: Int, lines: [String]) -> String? {
        let nextLineIndex = index + 1
        guard nextLineIndex < lines.count else { return nil }
        return lines[nextLineIndex]
    }
    
    private static func getWordsRanges(from string: String) -> [NSRange] {
        var ranges = [NSRange]()
        string.enumerateSubstrings(in: string.startIndex..<string.endIndex, options: [.byWords, .substringNotRequired]) {
            (_, textRange, _, _) in
            let wordRange = string.nsRange(from: textRange)
            ranges.append(wordRange)
        }
        return ranges
    }
    
    private static func concentrate(chordLine: inout String, lyricLine: inout String) -> String {
        func firstMatch(of string: String) -> XTag? {
            if let match = RegularExpression.chordsRegexForPlainText.firstMatch(in: string, range: string.nsRange()) {
                let subRange = match.range
                let subStr = (string as NSString).substring(with: subRange)
                return XTag(string: String(subStr), range: subRange)
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
            let chord = tag.string.bracked
            mutableChordLine.replaceCharacters(in: tag.range, with: String.makeEmptyString(for: chord.utf16.count))
            var location = tag.range.location
            let wordRanges = getWordsRanges(from: String(mutableLyricLine))
            wordRanges.forEach { range in
                if range.contains(location) {
                    location = range.location
                }
            }
            mutableLyricLine.replaceCharacters(in: .init(location: location, length: 0), with: chord)
        }
        return String(mutableLyricLine)
    }
    
    static func format(_ text: String) -> String {
        let text = correctSpellings(text)
        let textLines = text.lines()
        
        var newLines = [String]()
        var canSkip = false
        
        for (i, var line) in textLines.enumerated() {
            guard !canSkip else {
                canSkip = false
                continue
            }
            
            guard isChordLine(for: line) else {
                newLines.append(line)
                continue
            }
            
            guard var nextLine = nextLine(from: i, lines: textLines) else {
                newLines.append(line)
                continue
            }
            
            guard !isChordLine(for: nextLine) else {
                let bracked = RegularExpression.chordsRegexForPlainText.stringByReplacingMatches(in: line, withTemplate: "[$1]")
                print(bracked)
                newLines.append(bracked)
                continue
            }
            let concenerated = concentrate(chordLine: &line, lyricLine: &nextLine)
            newLines.append(concenerated)
            canSkip = true
        }
        
        return newLines.joined(separator: "\n")
    }
    
    static func correctSpellings(_ text: String) -> String {
        let isMyanmar = text.isMyanar
        
        var lines = [String]()
        text.components(separatedBy: .newlines).forEach { line in
            if isChordLine(for: line) {
                lines.append(SpellCorrector.correctedChordLine(line))
            } else if isMyanmar && line.isMyanar {
                lines.append(SpellCorrector.correctedMyanmarText(line))
            } else if !isMyanmar {
                lines.append(SpellCorrector.correctEnglishText(line))
            } else if line.isWhitespace {
                lines.append(line)
            }
        }
        return lines.joined(separator: "\n")
    }
}


