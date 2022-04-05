//
//  TextAttributes.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 24/3/22.
//

import UIKit

struct AttributedString {
    
    static func parse(from song: Song) -> NSAttributedString {
        let attrString = NSMutableAttributedString()
        song.sections.forEach {
            sectionView($0, attrString)
        }
        return attrString
    }
    
    static func createTitle(from song: Song) -> NSMutableAttributedString {
        let title = NSAttributedString(song.title ?? "", style: .title).mutable
        title.append(.init("\r" + (song.artist ?? "").newLine, style: .subheadline))
        return title
    }
    
    private static func sectionView(_ section:  Song.Sections,_ attrString: NSMutableAttributedString) {
        section.lines.forEach {
            lineView($0, attrString)
        }
        if !section.lines.isEmpty {
            attrString.newLine()
        }
    }
    
    private static func lineView(_ line: Song.Line,_ attrString: NSMutableAttributedString) {
        if let comment = line.comment?.trimmed() {
            commentView(comment, attrString)
        }else if let plain = line.plain?.trimmed() {
            plainView(plain, attrString)
        } else if let tablature = line.tablature?.trimmed() {
           tablatureView(tablature, attrString)
        } else if !line.measures.isEmpty {
            measuresViewText(line, attrString)
        } else {
            partsView(line, attrString)
        }
    }
    
    
    private static func measuresViewText(_ line: Song.Line,_ attrString: NSMutableAttributedString) {
        
//        var str  = "\n"
//        line.measures.forEach { measure in
//            str += "\n"
//            measure.chords.forEach { chord in
//                str += chord + " "
//            }
//            str += "\n"
//        }
//        str += "\n"
//        attrString.append(.init(str, style: .subheadline, foreGroundColor: .systemMint))
    }
    
    
    
    private static func partsView(_ line: Song.Line,_ attrString: NSMutableAttributedString) {
        if let chordLine = line.chordLine {
            attrString.append(chordLine.chordAttrStr)
        }
        
        if let lyricsLine = line.lyricsLine {
            attrString.append(lyricsLine.lyricAttrString())
        }
    }
    
    private static func tablatureView(_ string: String, _ attrString: NSMutableAttributedString) {
        string.lines().forEach { line in
            attrString.append(.init(string: line.newLine, attributes: [.font: XFont.chord(), .foregroundColor: UIColor.secondaryLabel, .paragraphStyle: NSParagraphStyle.nonLineBreak]))
        }
    }
    private static func plainView(_ string: String, _ attrString: NSMutableAttributedString) {
        string.lines().forEach { line in
            guard !line.isWhitespace else { return }
            attrString.append(.init(string: line.newLine, attributes: [.font: XFont.chord(), .foregroundColor: UIColor.systemOrange, .paragraphStyle: NSParagraphStyle.lineBreak]))
        }
    }
    private static func commentView(_ string: String, _ attrString: NSMutableAttributedString) {
        attrString.append(.init(string: string.newLine, attributes: [.font: XFont.chord(), .foregroundColor: UIColor.tertiaryLabel, .paragraphStyle: NSParagraphStyle.nonLineBreak]))
    }
}

extension AttributedString {
    
    static func displayText(for song: Song, with displayMode: Song.DisplayMode) -> NSAttributedString {
        let attrStr = self.createTitle(from: song)
        
        switch displayMode {
        case .Default:
            attrStr.append(self.parse(from: song))
        case .Editing:
            attrStr.append(self.rawText(from: song))
        case .TextOnly:
            attrStr.append(self.textOnly(from: song))
        case .Copyable:
            attrStr.append(self.copyableText(from: song))
        }
        return attrStr
    }
    private static func textOnly(from song: Song) -> NSAttributedString {
        .init(RegularExpression.chordPattern.stringByReplacingMatches(in: song.rawText, withTemplate: String()))
    }
    private static func rawText(from song: Song) -> NSAttributedString {
        .init(song.rawText)
    }
    private static func copyableText(from song: Song) -> NSAttributedString {
        let rawText = song.rawText
        let mutable = NSMutableAttributedString(rawText.replacingOccurrences(of: "[", with: " ").replacingOccurrences(of: "]", with: " "))
        
        let items = getChordTags(for: rawText)
        
        items.forEach { tag in
            mutable.addAttributes(tag.customTextAttributes, range: tag.range)
        }
        return mutable
    }
    
    static func getChordTags(for rawText: String) -> [ChordTag] {
        var items = [ChordTag]()
        RegularExpression.chordPattern.matches(in: rawText, range: rawText.range()).forEach { match in
            let nsString = rawText as NSString
            let tagRange = match.range // (location: 20, length: 3]
            let subString = nsString.substring(with: tagRange) // [G]
            let chord = subString
            let item = ChordTag.init(chord: chord, range: tagRange)
            items.append(item)
        }
        return items
    }
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
    
     func adjustFontRatio(factor: CGFloat) {
        self.enumerateAttribute(.font, in: NSRange(location: 0, length: self.length)) { value, range, pointer in
            if let font = value as? UIFont {
                self.removeAttribute(.font, range: range)
                self.addAttribute(.font, value: font.withSize(font.pointSize * factor), range: range)
            }
        }
    }
    
    func adjustFontSize(to availiableWidth: CGFloat) {
        var percent: CGFloat = 1
        beginEditing()
        while availiableWidth < self.size(for: CGSize(width: .greatestFiniteMagnitude, height: availiableWidth*2)).width  {
            percent -= 0.01
            adjustFontRatio(factor: percent)
        }
        endEditing()
    }
}

extension String {
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    var chordAttrStr: NSMutableAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [.font: XFont.chord(), .foregroundColor: UIColor.red, .paragraphStyle: NSParagraphStyle.nonLineBreak]
        return .init(string: self, attributes: attributes)
    }
    
    func lyricAttrString() -> NSMutableAttributedString {
        .init(self)
    }
}
