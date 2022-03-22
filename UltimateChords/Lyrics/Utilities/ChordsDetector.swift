//
//  ChordsDetector.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 18/3/22.
//

import Foundation

struct LyricsTags {
    let text: String
    let tags: [DPTag]
}

protocol TagDetection {
    func detectTags(from string: String, with regx: NSRegularExpression) -> [DPTag]
}

extension TagDetection {
    
    func detectTags(from string: String, with regx: NSRegularExpression) -> [DPTag] {
        let nsString = string as NSString
        var tags = [DPTag]()
        regx.enumerateMatches(in: string, options: [], range: nsString.range()) { result, matches, pointer in
            if let result = result {
                let subRange = result.range
                let subString = nsString.substring(with: subRange)
                let tag = DPTag(name: subString, range: subRange)
                tags.append(tag)
                
            }
        }
        return tags
    }
}

protocol ChordDetection: TagDetection {
    func detectChord(from string: String) -> LyricsTags
}

extension ChordDetection {
    
    func detectChord(from string: String) -> LyricsTags {
        
        var newLines = [String]()
        
        string.lines().forEach {
            var line = $0
            
            var stringRangeArray = [(String, NSRange)]()
            
            while let match = RegularExpression.shared.chordPattern.firstMatch(in: line, range: NSRange(location: 0, length: line.utf16.count)), match.numberOfRanges > 0 {
                let subRange = match.range
                let subString = (line as NSString).substring(with: subRange)
                
                if let range = Range(subRange, in: line) {
                    stringRangeArray.append((subString, subRange))
                    line = line.replacingCharacters(in: range, with: String())
                }
            }
            if stringRangeArray.count > 0 {
                var chordString = ""
                
                for _ in 0...line.utf16.count+3 {
                    chordString += " "
                }
                
                stringRangeArray.forEach { strRange in
                    if let range = Range(strRange.1, in: chordString) {
                        chordString = chordString.replacingCharacters(in: range, with: strRange.0)
                    }
                }
                newLines.append(chordString)
                
            }
            newLines.append(line)
        }
        
        let newString = newLines.joined(separator: "\n")
        
        let tags = detectTags(from: newString, with: RegularExpression.shared.chordPattern)
        let finalString = RegularExpression.shared.chordPattern.stringByReplacingMatches(in: newString, withTemplate: "$1  ")
        return .init(text: finalString, tags: tags)
    }
}
