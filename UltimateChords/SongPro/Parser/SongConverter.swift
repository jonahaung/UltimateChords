// MARK: - class: ChordPro

/// The chordpro format parser.
/// Very modified version of the "songpro-swift" parser:
/// https://github.com/SongProOrg/songpro-swift

import SwiftUI
import SwiftyChords

class SongConverter {
    
    static let defineRegex = try? NSRegularExpression(pattern: "([a-z0-9#b/]+)(.*)", options: .caseInsensitive)
    static let lyricsRegex = try? NSRegularExpression(pattern: "(\\[[\\w#b/]+])?([^\\[]*)", options: .caseInsensitive)
    static let measuresRegex = try? NSRegularExpression(pattern: "([\\[[\\w#b\\/]+\\]\\s]+)[|]*", options: .caseInsensitive)
    static let chordsRegex = try? NSRegularExpression(pattern: "\\[([\\w#b\\/]+)\\]?", options: .caseInsensitive)
    
    static func parse(rawText: String) -> Song {
        
        var song = Song(rawText: rawText)
        
        rawText.components(separatedBy: "{").forEach {
            guard !$0.isWhitespace else { return }
            let str = "{" + $0
            var currentSection = Song.Sections()
            song.sections.append(currentSection)
            processDirective(text: str, song: &song, currentSection: &currentSection)
        }
        return song
    }
    

    private static func processDirective(text: String, song: inout Song, currentSection: inout  Song.Sections) {
        
        var key: String?
        var value: String?
        
        if let match = RegularExpression.directivePattern.firstMatch(in: text, range: text.nsRange()) {
            
            if let keyRange = Range(match.range(at: 1), in: text) {
                key = text[keyRange].trimmingCharacters(in: .newlines)
            }
            if let valueRange = Range(match.range(at: 2), in: text) {
                value = text[valueRange].trimmingCharacters(in: .whitespacesAndNewlines)
                
                switch key {
                case "t", "title":
                    song.title = value!
                case "st", "subtitle", "artist":
                    song.artist = value!
                case "capo":
                    song.capo = value!
                case "time":
                    song.time = value!
                case "c", "comment":
                    processComments(text: value!, song: &song, currentSection: &currentSection)
                case "sog":
                    processSection(text: value!, type: "grid", song: &song, currentSection: &currentSection)
                case "chorus":
                    currentSection.sectionKind = .Cho
                    processSection(text: value!, type: "chorus", song: &song, currentSection: &currentSection)
                    currentSection =  Song.Sections()
                    song.sections.append(currentSection)
                case "define":
                    processDefine(text: value!, song: &song)
                case "key":
                    song.key = value!
                case "tempo":
                    song.tempo = value!
                case "year":
                    song.year = value!
                case "album":
                    song.album = value!
                case "tuning":
                    song.tuning = value!
                case "musicpath":
                    if let path = song.path {
                        var musicpath = path.deletingLastPathComponent()
                        musicpath.appendPathComponent(value!)
                        song.musicpath = musicpath
                    }
                default:
                    break
                }
            }
        }
        
        
        /// Second, stuff without a value
        if let match = RegularExpression.directiveEmptyRegex.firstMatch(in: text, range: text.nsRange()) {
            
            if let keyRange = Range(match.range(at: 1), in: text) {
                key = text[keyRange].trimmingCharacters(in: .newlines)
                switch key {
                case "soc":
                    currentSection.sectionKind = .Cho
                    processSection(text: "Chorus", type: "chorus", song: &song, currentSection: &currentSection)
                case "sot":
                    currentSection.sectionKind = .Tab
                    processSection(text: "", type: "tab", song: &song, currentSection: &currentSection)
                case "sog":
                    processSection(text: "", type: "grid", song: &song, currentSection: &currentSection)
                case "sov":
                    currentSection.sectionKind = .Verse
                    processSection(text: "Verse", type: "verse", song: &song, currentSection: &currentSection)
                case "chorus":
                    currentSection.sectionKind = .Cho
                    processSection(text: "Repeat chorus", type: "chorus", song: &song, currentSection: &currentSection)
                    currentSection =  Song.Sections()
                    song.sections.append(currentSection)
                default:
                    break
                }
            }

        }
        text.lines().forEach { line in
            if line.starts(with: "{") {
                let line = Song.Line()
                if currentSection.sectionKind == .Tab {
                    line.tablature = currentSection.name
                } else {
                    line.plain = currentSection.name
                }
                currentSection.lines.append(line)
            } else {
                processLyrics(text: line, song: &song, currentSection: &currentSection)
            }
        }
    }
    
    
    // MARK: - func: processSection
    fileprivate static func processSection(text: String, type: String, song: inout Song, currentSection: inout  Song.Sections) {
        if currentSection.lines.isEmpty {
            /// There is already an empty section
            currentSection.type = type
            currentSection.name = text
        } else {
            /// Make a new section
            currentSection =  Song.Sections()
            currentSection.type = type
            currentSection.name = text
            song.sections.append(currentSection)
        }
    }
    
    // MARK: - func: processDefine; chord definitions
    fileprivate static func processDefine(text: String, song: inout Song) {
        var key = ""
        var value = ""
        if let match = defineRegex?.firstMatch(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count)) {
            if let keyRange = Range(match.range(at: 1), in: text) {
                key = text[keyRange].trimmingCharacters(in: .newlines)
            }
            
            if let valueRange = Range(match.range(at: 2), in: text) {
                value = text[valueRange].trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
        let chord = Chord.chord(for: key)
//        if let index = song.chords.firstIndex(where: { $0.name == chord?.key.rawValue }) {
//            song.chords[index].define = value
//        }
    }
    
    // MARK: - func: processComments
    fileprivate static func processComments(text: String, song: inout Song, currentSection: inout  Song.Sections) {
        let line = Song.Line()
        line.comment = text.trimmingCharacters(in: .newlines)
        /// Add the comment as a new line.
        currentSection.lines.append(line)
    }
    
    // MARK: - func: processLyrics
    fileprivate static func processLyrics(text: String, song: inout Song, currentSection: inout  Song.Sections) {
        
        /// Start with a fresh line:
        var line = Song.Line()
        
        if text.starts(with: "|-") || currentSection.type == "tab" {
            if currentSection.type == nil {
                currentSection.type = "tab"
            }
            line.tablature = text
        } else if text.starts(with: "| ") {
            if currentSection.type == nil {
                currentSection.type = "grid"
            }
            if let measureMatches = measuresRegex?.matches(in: text, range: text.nsRange()) {
                var measures = [Song.Measure]()
                
                for match in measureMatches {
                    if let measureRange = Range(match.range(at: 1), in: text) {
                        let measureText = text[measureRange].trimmingCharacters(in: .newlines)
                        if let chordsMatches = chordsRegex?.matches(in: measureText, range: NSRange(location: 0, length: measureText.utf16.count)) {
                            
                            let measure = Song.Measure()
                            measure.chords = chordsMatches.map {
                                if let chordsRange = Range($0.range(at: 1), in: measureText) {
                                    return String(measureText[chordsRange].trimmingCharacters(in: .newlines))
                                }
                                return ""
                            }
                            measures.append(measure)
                        }
                    }
                }
                line.measures = measures
            }
        } else {
            processParts(text, song: &song, currentSection: &currentSection, line: &line)
        }
        line.parts.forEach { part in
            if !song.chords.contains(where: { $0.name == part.chord! }) {
                if var chord = Chord.chord(for: part.chord!) {
                    chord.name = part.chord!
                    song.chords.append(chord)
                }
                
            }
        }
        currentSection.lines.append(line)
    }
    
    
    private static func processParts(_ text: String, song: inout Song, currentSection: inout  Song.Sections, line: inout Song.Line) {
        
        let font = XFont.body(for: text)
        let cFont = XFont.chord()
        
        text.lines().forEach { string in
            
            var chordLine = String()
            var wordLine = String()
            
            
            lyricsRegex!.matches(in: string, range: string.nsRange()).forEach { match in
                var chord = ""
                var word = ""
                
                if let keyRange = Range(match.range(at: 1), in: string) {
                    chord = String(string[keyRange])
                    chord = RegularExpression.chordPattern.stringByReplacingMatches(in: chord, withTemplate: "$1")
                    
                    if currentSection.type == nil {
                        currentSection.type = "verse"
                    }
                    /// Use the first chord as key for the song if not set.
                    if song.key == nil {
                        song.key = chord
                    }
                    
                }
                
                if let valueRange = Range(match.range(at: 2), in: string) {
                    /// See https://stackoverflow.com/questions/31534742/space-characters-being-removed-from-end-of-string-uilabel-swift
                    /// for the funny stuff added to the string...
//                    word = String(string[valueRange] + "\u{200c}")
                    word = String(string[valueRange])
                }
                
                let part = Song.Part()
                part.chord = chord
                part.lyric = word
                
                if !(part.empty) {
                    line.parts.append(part)
                    chordLine += chord
                    wordLine += word
                    
                    while chordLine.widthOfString(usingFont: cFont) + cFont.pointSize < wordLine.widthOfString(usingFont: font) {
                        chordLine += " "
                    }
                    chordLine += " "
                }
            }
            
            if !chordLine.isWhitespace {
                line.chordLine = chordLine.newLine
            }
            if !wordLine.isWhitespace {
                line.lyricsLine = wordLine.newLine
            }
        }
    }
    
    private static func processLines(_ text: String, song: inout Song, currentSection: inout  Song.Sections, line: inout Song.Line) {
        func processLines(textLines: [String]) {
            for var textLine in textLines {
                
                var chordLine = String()
                
                while let match = RegularExpression.chordPattern.firstMatch(in: textLine, options: [], range: textLine.nsRange()) {
                    
                    let nsString = textLine as NSString
                    let subRange = match.range
                    let subString = nsString.substring(with: subRange)
                    
                    textLine = (textLine as NSString).replacingCharacters(in: subRange, with: "")
                    
                    
                    let chord = String(subString)
                    if chordLine.utf16.count >= subRange.location {
                        
                        chordLine += chord
                    } else {
                        while chordLine.utf16.count < subRange.location {
                            chordLine += " "
                        }
                        chordLine += chord
                    }
                }
                
                chordLine = RegularExpression.chordPattern.stringByReplacingMatches(in: chordLine, withTemplate: "$1")
                if !chordLine.isWhitespace {
                    line.chordLine = chordLine.newLine

                }
                if !textLine.isWhitespace {
                    line.lyricsLine = textLine.newLine
                }
            }
        }
        processLines(textLines: text.lines())
    }
}
