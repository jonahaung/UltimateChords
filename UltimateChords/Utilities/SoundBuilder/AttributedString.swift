//
//  TextAttributes.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 24/3/22.
//

import UIKit
import SwiftUI

struct AttributedString {
    
    static func parse(from song: Song) -> NSAttributedString {
        var attrString = createTitle(from: song)
        song.sections.forEach {
            sectionView($0, &attrString)
        }
        return attrString
    }
    
    private static func createTitle(from song: Song) -> NSMutableAttributedString {
        let title = NSAttributedString(song.title ?? "", style: .title).mutable
        title.append(.init("\r" + (song.artist ?? "").newLine, style: .subheadline))
        return title
    }
    
    private static func sectionView(_ section: Sections,_ attrString: inout NSMutableAttributedString) {
        section.lines.forEach {
            lineView($0, &attrString)
        }
        attrString.newLine()
        attrString.newLine()
    }
    
    private static func lineView(_ line: Line,_ attrString: inout NSMutableAttributedString) {
        if let comment = line.comment {
            let commentView = NSAttributedString(string: comment.newLine, attributes: [.foregroundColor: UIColor.secondaryLabel, .font: UIFont.italicSystemFont(ofSize: 15)])
            attrString.append(commentView)
        }
        if let plain = line.plain {
            let x = NSAttributedString(string: plain.trimmed().newLine, attributes: [.foregroundColor: UIColor.systemMint, .font: UIFont.systemFont(ofSize: UIFont.labelFontSize)])
            attrString.append(x)
        }
        if !line.measures.isEmpty {
            measuresViewText(line, &attrString)
        } else if let tablature = line.tablature {
            attrString.append(.init(tablature, style: .body, foreGroundColor: .systemRed))
            attrString.newLine()
        } else {
            partsView(line, &attrString)
        }
    }
    
    
    private static func measuresViewText(_ line: Line,_ attrString: inout NSMutableAttributedString) {
        
        var str  = "\n"
        line.measures.forEach { measure in
            str += "\n"
            measure.chords.forEach { chord in
                str += chord + " "
            }
            str += "\n"
        }
        str += "\n"
        attrString.append(.init(str, style: .subheadline, foreGroundColor: .systemMint))
    }
    
    
    
    private static func partsView(_ line: Line,_ attrString: inout NSMutableAttributedString) {
        if let chordLine = line.chordLine {
            attrString.append(chordLine.chordAttrStr)
        }
        
        if let lyricsLine = line.lyricsLine {
            attrString.append(lyricsLine.lyricAttrString())
        }
        
//        let lineString = NSMutableAttributedString()
//        line.parts.forEach { part in
//            let lyrics = part.lyric?.trimmed() ?? " "
//            var chord = part.chord?.trimmed() ?? String()
//
//            if lyrics.isWhitespace {
//                chord += "-"
//            }
//            let fullLine = chord+lyrics
//
//            let partString = NSMutableAttributedString(fullLine)
//
//            partString.setAttributes([.baselineOffset: lyrics.isWhitespace ? 0 : UIFont.labelFontSize, .font: XFont.chord(), .foregroundColor: UIColor.systemPink], range: NSRange(location: 0, length: chord.utf16.count))
//
//            lineString.append(partString)
//        }
//
//        if !lineString.string.isWhitespace {
//            attrString.append(lineString)
//            attrString.newLine()
//        }
       
    }
    
    private static func plainView(_ line: Line,_ attrString: inout NSMutableAttributedString) {
        var html = String()
        line.parts.forEach { part in
            html += part.lyric!.trimmed()
        }
        html += "\r"
        attrString.append(.init(html))
    }
    
    static let chordAttributes: [NSMutableAttributedString.Key: Any] = [.font: XFont.chord(), .foregroundColor: UIColor.systemPink, .paragraphStyle: NSParagraphStyle.chord, .baselineOffset: 0.7]
}
extension NSAttributedString {
    
    convenience init(_ string: String, style: XFont.Style = .body, foreGroundColor: UIColor = .label) {
        let font: UIFont
        switch style {
        case .title:
            font = XFont.title(for: string)
        case .footnote:
            font = XFont.footnote(for: string)
        case .subheadline:
            font = XFont.subheadline(for: string)
        case .body:
            font = XFont.body(for: string)
        case .headline:
            font = XFont.headline(for: string)
        }
        self.init(string: string, attributes: [.font: font, .foregroundColor: foreGroundColor, .paragraphStyle: NSParagraphStyle.nonLineBreak])
    }
    
    var mutable: NSMutableAttributedString { NSMutableAttributedString(attributedString: self) }
    var attributes: [NSMutableAttributedString.Key: Any] { self.attributes(at: 0, effectiveRange: nil) }
    
    func size(for largestSize: CGSize) -> CGSize {
        let framesetter = CTFramesetterCreateWithAttributedString(self)
        return CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRange(), nil, largestSize, nil)
    }
}

extension NSMutableAttributedString {
    func newLine() {
        append(.init(string: "\r"))
    }
}
extension String {

    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }

    var chordAttrStr: NSMutableAttributedString {
        .init(string: self, attributes: AttributedString.chordAttributes)
    }
    
    func lyricAttrString() -> NSMutableAttributedString {
        .init(self)
    }
}
