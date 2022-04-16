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
        return RegularExpression.chordsRegexForPlainText.matches(in: line, range: line.range()).isEmpty == false
    }
    
    private static func nextLine(from index: Int, lines: [String]) -> String? {
        guard index+1 < lines.count else { return nil }
        return lines[index+1]
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
            if let match = RegularExpression.chordsRegexForPlainText.firstMatch(in: string, range: string.range()) {
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
            
            mutableChordLine.replaceCharacters(in: tag.range, with: makeEmptyString(for: chord.utf16.count))
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
    
    private static func makeEmptyString(for i: Int) -> String {
        var str = String()
        (0..<i).forEach { _ in
            str += "-"

        }
        return str
    }
    
    static func convert(_ text: String) -> String {
        
        let textLines = text.components(separatedBy: "\n")
        
        var newLines = [String]()
        
        var canSkip = false
        
        for (i, var line) in textLines.enumerated() {
            guard !canSkip else { canSkip = false; continue }
            
            guard isChordLine(for: line) else {
                newLines.append(line)
                continue
            }
            
            guard var nextLine = nextLine(from: i, lines: textLines) else {
                newLines.append(line)
                continue
            }
            
            guard isChordLine(for: nextLine) == false else {
                newLines.append(line)
                continue
            }
            let concenerated = concentrate(chordLine: &line, lyricLine: &nextLine)
            newLines.append(concenerated)
            canSkip = true
        }
        return newLines.joined(separator: "\n")
    }
}


