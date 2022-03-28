//
//  Song.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 17/3/22.
//

import Foundation
import UIKit

class Lyrics: Identifiable {
    
    let id: String
    var title: String
    var artist: String
    var text: String
    
    init(id: String = UUID().uuidString, title: String, artist: String, text: String) {
        self.id = id
        self.title = title
        self.artist = artist
        self.text = text
    }
    
    convenience init(cLyrics: CLyrics) {
        self.init(id: cLyrics.id!, title: cLyrics.title ?? "", artist: cLyrics.artist ?? "", text: cLyrics.text ?? "")
    }
    
    
    
}

extension Lyrics {
    
    func textOnly() -> NSAttributedString {
        
        let attrStr = createTitle()
        let text = RegularExpression.chordPattern.stringByReplacingMatches(in: self.text, withTemplate: String())
        attrStr.append(.init(text))
        return attrStr
    }
    
    func chordProText() -> NSAttributedString {
        let mutable = NSAttributedString(text).mutable
        
        getChordTags().forEach {
            mutable.addAttributes($0.customTextAttributes, range: $0.range)
        }
        
        let attrStr = createTitle()
        attrStr.append(mutable)
        
        return attrStr
    }
    
    
    private func getChordTags() -> [ChordTag] {

        let nsString = self.text as NSString
        
        var tags = [ChordTag]()
        RegularExpression.chordPattern.enumerateMatches(in: self.text, options: [], range: text.range()) { result, matches, pointer in
            guard let result = result else {
                return
            }
            let subRange = result.range
            let subString = nsString.substring(with: subRange)
            
            let tag = ChordTag(name: subString, range: subRange)
            tags.append(tag)
        }
        return tags
    }
    
    func pdfData() -> Data? {
        return Pdf.data(from: ChordPro.parse(string: text).attributedText)
    }
    
    
    
    private func createTitle() -> NSMutableAttributedString {
        let title = NSAttributedString(self.title, style: .title).mutable
        title.append(.init("\r" + self.artist.newLine, style: .subheadline))
        return title
    }
    
   
    private func redableText() -> NSAttributedString {
        let attrStr = createTitle()
        func processLines(textLines: [String]) {
            
            for var textLine in textLines {
                var chordLine = String()
                
                while let match = RegularExpression.chordPattern.firstMatch(in: textLine, options: [], range: textLine.range()) {
        
                    let nsString = textLine as NSString
                    let subRange = match.range
                    let subString = nsString.substring(with: subRange)
                    
                    textLine = (textLine as NSString).replacingCharacters(in: subRange, with: "\u{200c}")
                   
                    if chordLine.utf16.count >= subRange.location {
                        chordLine += String(subString)
                    } else {
                        while chordLine.utf16.count < subRange.location {
                            chordLine += " "
                        }
                        chordLine += String(subString)
                    }
                }
                
                chordLine = RegularExpression.chordPattern.stringByReplacingMatches(in: chordLine, withTemplate: "$1")
                if !chordLine.isWhitespace {
                    attrStr.append(.init(chordLine.newLine, foreGroundColor: UIColor.systemRed))
                }
                if !textLine.isWhitespace {
                    attrStr.append(.init(textLine.newLine))
                }
            }
        }
        processLines(textLines: text.lines())
        
        return attrStr
    }
    
    
}

extension String {
    
    func splitByLength(_ length: Int, seperator: String) -> [String] {
        var result = [String]()
        var collectedWords = [String]()
        collectedWords.reserveCapacity(length)
        var count = 0

        for word in self.components(separatedBy: seperator) {
            count += word.count + 1 //add 1 to include space
            if (count > length) {
                result.append(collectedWords.map { String($0) }.joined(separator: seperator) )
                collectedWords.removeAll(keepingCapacity: true)

                count = word.count
            }
            
            collectedWords.append(word)
        }

        // Append the remainder
        if !collectedWords.isEmpty {
            result.append(collectedWords.map { String($0) }.joined(separator: seperator))
        }

        return result
    }
}


extension String {
    func size(OfFont font: UIFont) -> CGSize {
        return (self as NSString).size(withAttributes: [NSAttributedString.Key.font: font])
    }
}
