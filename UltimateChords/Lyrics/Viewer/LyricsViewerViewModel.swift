//
//  LyricsViewerViewModel.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 18/3/22.
//

import UIKit

class LyricsViewerViewModel: NSObject, ObservableObject {

    var lyrics: Lyrics
    @Published var attributedText: NSAttributedString?
    @Published var pdfData: Data?
    
    init(_ lyrics: Lyrics) {
        self.lyrics = lyrics
        attributedText = NSAttributedString(string: lyrics.text, attributes: [.font: lyrics.textFont(), .paragraphStyle: NSParagraphStyle.nonLineBreak])
    }
}

extension LyricsViewerViewModel: ChordDetection {
    func makePDF() {
        if let x = attributedText, let url = Pdf.createPdf(from: x) {
            pdfData = try? Data.init(contentsOf: url)
        }
    }
    
    func detect() {
        let text = lyrics.text
        let data = detectChord(from: text)
        let attr = NSMutableAttributedString(string: data.text, attributes: [.paragraphStyle: NSMutableParagraphStyle.nonLineBreak, .font: data.text.language == "my" ? XFont.mmUiFont(.Label) : XFont.uiFont(weight: .Medium, .Label)])
        data.tags.forEach { tag in
            attr.setAttributes(tag.customTextAttributes, range: tag.range)
        }
        self.attributedText = attr
    }
    
    private func detectSong() {
        let song = SongPro.parse(lyrics.text)
        
        let attributedText = NSMutableAttributedString(string: String())
        
        if let title = song.title {
            attributedText.append(.init(string: title, attributes: [.font: XFont.uiFont(weight: .SemiBold, .Button)]))
        }
        if let artist = song.artist {
            attributedText.append(.init(string: "\n" + artist + "\n", attributes: [.font: XFont.uiFont(weight: .Medium, .System)]))
        }
        
        song.sections.forEach { section in
            
            var lines = [String]()
            
            if let name = section.name {
                attributedText.append(.init(string: "\n" + name + "\n", attributes: [.font: XFont.uiFont(weight: .Regular, .System), .foregroundColor: UIColor.systemIndigo]))
            }
            
            section.lines.forEach { line in
                if !line.parts.isEmpty {
                    var lineParts = [String]()
                    line.parts.forEach { part in
                        if let chord = part.chord, let lyric = part.lyric {
                            let linePart = "[\(chord)]" + lyric
                            lineParts.append(linePart)
                        }
                    }
                    let line = lineParts.joined(separator: " ")
                    lines.append(line)
                }
            }
            
            if !lines.isEmpty {
                let data = detectChord(from: lines.joined(separator: "\n"))
                
                let attrText = NSMutableAttributedString(string: data.text, attributes: [.font: lyrics.isMyanmar ? XFont.mmFont(.Label) : XFont.uiFont()])
                
                if !data.tags.isEmpty {
                    data.tags.forEach { tag in
                        attrText.addAttributes(tag.customTextAttributes, range: tag.range)
                    }
                }
                attributedText.append(attrText)
            }
        }
        
        self.attributedText = attributedText
    }
}
extension LyricsViewerViewModel: WidthFittingTextViewDelegate {
    
    func textView(_ textView: WidthFittingTextView, didAdjustFontSize fontSize: CGFloat) {
//        self.attributedText = textView.attributedText
//        print(fontSize)
    }
    
    func textViewDidChange(_ textView: WidthFittingTextView) {
        
    }
}
