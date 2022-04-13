//
//  PlainTextParser.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 10/4/22.
//

import Foundation

struct SongParser {
    
    private static func isChordLine(line: String) -> Bool {
        RegularExpression.chordsRegexForPlainText.matches(in: line, range: line.range()).count > 0
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
            let location = tag.range.location - (tag.range.location == 0 ? 0 : 1)
            mutableLyricLine.replaceCharacters(in: .init(location: location, length: 0), with: chord)
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
        var canSkip = false
        for (i, textLine) in textLines.enumerated() {
            guard !canSkip else {
                canSkip = false
                continue
            }
            
            if isChordLine(line: textLine) {
                var chordLine = textLine
                
                if let nextLine = nextLine(from: i, lines: textLines)  {
                    
                    if isChordLine(line: nextLine) {
                        newLines.append(textLine)
                    } else {
                        var lyricLine = nextLine
                        
                        let concenerated = concentrate(chordLine: &chordLine, lyricLine: &lyricLine)
                        newLines.append(concenerated)
                        canSkip = true
                    }
                    
                } else {
                    newLines.append(textLine)
                }
            } else {
                if newLines.last != textLine {
                    newLines.append(textLine)
                }
                
            }
        }
        return newLines.joined(separator: "\n")
    }
}
struct Resegment {
    
    private static let RESEGMENT_REGULAR_EX = "(?:(?<!္)([က-ဪဿ၊-၏]|[၀-၉]+|[^က-၏]+)(?![ှျ]?[့္်]))"
    
    static func segment(_ text : String) -> [String] {
        
        var outputs  = text.replacingOccurrences(of: RESEGMENT_REGULAR_EX, with: "𝕊$1", options: [.regularExpression, .caseInsensitive])
    
        
        var ouputArray = outputs.components(separatedBy: "𝕊")
        
        if (ouputArray.count > 0) {
            ouputArray.remove(at: 0)
        }
        
        return ouputArray
    }
}
extension String {
    func nsRange(from range: Range<String.Index>) -> NSRange {
        let from = range.lowerBound.samePosition(in: utf16)!
        let to = range.upperBound.samePosition(in: utf16)!
        return NSRange(location: utf16.distance(from: utf16.startIndex, to: from),
                       length: utf16.distance(from: from, to: to))
    }
}

extension String {
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location + nsRange.length, limitedBy: utf16.endIndex),
            let from = from16.samePosition(in: self),
            let to = to16.samePosition(in: self)
            else { return nil }
        return from ..< to
    }
}
