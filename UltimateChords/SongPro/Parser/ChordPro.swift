// MARK: - class: ChordPro

/// The chordpro format parser.
/// Very modified version of the "songpro-swift" parser:
/// https://github.com/SongProOrg/songpro-swift

import SwiftUI
import SwiftyChords

class ChordPro {
    
    static let directiveRegex = try? NSRegularExpression(pattern: "\\{(\\w*):([^%]*)\\}")
    static let directiveEmptyRegex = try? NSRegularExpression(pattern: "\\{(\\w*)\\}")
    static let defineRegex = try? NSRegularExpression(pattern: "([a-z0-9#b/]+)(.*)", options: .caseInsensitive)
    static let lyricsRegex = try? NSRegularExpression(pattern: "(\\[[\\w#b/]+])?([^\\[]*)", options: .caseInsensitive)
    static let measuresRegex = try? NSRegularExpression(pattern: "([\\[[\\w#b\\/]+\\]\\s]+)[|]*", options: .caseInsensitive)
    static let chordsRegex = try? NSRegularExpression(pattern: "\\[([\\w#b\\/]+)\\]?", options: .caseInsensitive)
    
    static func parse(string: String) -> Song {
        var song = Song()
        song.rawText = string
        var currentSection = Sections()
        song.sections.append(currentSection)
        string.lines().forEach { line in
            if line.starts(with: "{") {
                processDirective(text: line, song: &song, currentSection: &currentSection)
            } else if line.starts(with: "#"){
                let songLine = Line()
                songLine.comment = line
                currentSection.lines.append(songLine)
            } else {
                processLyrics(text: line, song: &song, currentSection: &currentSection)
            }
        }
        
        if currentSection.lines.isEmpty {
            song.sections.removeLast()
        }
        return song
    }
    
    // MARK: - func: processDirective
    fileprivate static func processDirective(text: String, song: inout Song, currentSection: inout Sections) {
        var key: String?
        var value: String?
        
        
        if let match = RegularExpression.directivePattern.firstMatch(in: text, range: text.range()) {
            if let keyRange = Range(match.range(at: 1), in: text) {
                key = text[keyRange].trimmingCharacters(in: .newlines)
            }
            if let valueRange = Range(match.range(at: 2), in: text) {
                value = text[valueRange].trimmingCharacters(in: .whitespacesAndNewlines)
            }
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
            case "soc":
                currentSection.sectionKind = .Cho
                processSection(text: value!, type: "chorus", song: &song, currentSection: &currentSection)
            case "sot":
                currentSection.sectionKind = .Tab
                processSection(text: value!, type: "tab", song: &song, currentSection: &currentSection)
            case "sov":
                currentSection.sectionKind = .Verse
                processSection(text: value!, type: "verse", song: &song, currentSection: &currentSection)
            case "sog":
                processSection(text: value!, type: "grid", song: &song, currentSection: &currentSection)
            case "chorus":
                currentSection.sectionKind = .Cho
                processSection(text: value!, type: "chorus", song: &song, currentSection: &currentSection)
                currentSection = Sections()
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
        
        
        /// Second, stuff without a value
        if let match = directiveEmptyRegex?.firstMatch(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count)) {
            if let keyRange = Range(match.range(at: 1), in: text) {
                key = text[keyRange].trimmingCharacters(in: .newlines)
            }
            switch key {
            case "soc":
                processSection(text: "Chorus", type: "chorus", song: &song, currentSection: &currentSection)
            case "sot":
                processSection(text: "Tab", type: "tab", song: &song, currentSection: &currentSection)
            case "sog":
                processSection(text: "", type: "grid", song: &song, currentSection: &currentSection)
            case "sov":
                processSection(text: "Verse", type: "verse", song: &song, currentSection: &currentSection)
            case "chorus":
                processSection(text: "Repeat chorus", type: "chorus", song: &song, currentSection: &currentSection)
                currentSection = Sections()
                song.sections.append(currentSection)
            default:
                break
            }
        }
    }
    
    
    // MARK: - func: processSection
    fileprivate static func processSection(text: String, type: String, song: inout Song, currentSection: inout Sections) {
        if currentSection.lines.isEmpty {
            /// There is already an empty section
            currentSection.type = type
            currentSection.name = type
        } else {
            /// Make a new section
            currentSection = Sections()
            currentSection.type = type
            currentSection.name = type
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
        let process = processChord(chord: key)
        if let index = song.chords.firstIndex(where: { $0.name == process.key.rawValue }) {
            song.chords[index].define = value
        }
    }
    
    // MARK: - func: processComments
    fileprivate static func processComments(text: String, song: inout Song, currentSection: inout Sections) {
        let line = Line()
        line.comment = text.trimmingCharacters(in: .newlines)
        /// Add the comment as a new line.
        currentSection.lines.append(line)
    }
    
    // MARK: - func: processLyrics
    fileprivate static func processLyrics(text: String, song: inout Song, currentSection: inout Sections) {
        if text.isEmpty {
            if !currentSection.lines.isEmpty {
                currentSection = Sections()
                song.sections.append(currentSection)
            }
            return
        }
        
        /// Start with a fresh line:
        var line = Line()
        
        if text.starts(with: "|-") || currentSection.type == "tab" {
            if currentSection.type == nil {
                currentSection.type = "tab"
            }
            line.tablature = text
        } else if text.starts(with: "| ") {
            if currentSection.type == nil {
                currentSection.type = "grid"
            }
            if let measureMatches = measuresRegex?.matches(in: text, range: text.range()) {
                var measures = [Measure]()
                
                for match in measureMatches {
                    if let measureRange = Range(match.range(at: 1), in: text) {
                        let measureText = text[measureRange].trimmingCharacters(in: .newlines)
                        if let chordsMatches = chordsRegex?.matches(in: measureText, range: NSRange(location: 0, length: measureText.utf16.count)) {
                            
                            let measure = Measure()
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
                let process = processChord(chord: part.chord!)
                let chord = Chord(name: part.chord!, key: process.key, suffix: process.suffix, define: "")
                song.chords.append(chord)
            }
        }
        currentSection.lines.append(line)
    }
    
    
    private static func processParts(_ text: String, song: inout Song, currentSection: inout Sections, line: inout Line) {
        
        let font = XFont.body(for: text)
        let cFont = XFont.chord()
        
        text.lines().forEach { string in
            
            var chordLine = String()
            var wordLine = String()
            
            
            lyricsRegex!.matches(in: string, range: string.range()).forEach { match in
                var chord = ""
                var word = ""
                
                if let keyRange = Range(match.range(at: 1), in: string) {
                    chord = string[keyRange]
                        .trimmingCharacters(in: .newlines)
                        .replacingOccurrences(of: "[", with: "")
                        .replacingOccurrences(of: "]", with: "")
                    
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
                    word = String(string[valueRange] + "\u{200c}")
                }
                
                let part = Part()
                part.chord = chord
                part.lyric = word
                
                if !(part.empty) {
                    line.parts.append(part)
                    
                    chordLine += chord
                    wordLine += word
                    
                    while chordLine.widthOfString(usingFont: cFont) < wordLine.widthOfString(usingFont: font) {
                        chordLine += " "
                    }
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
    
    private static func processLines(_ text: String, song: inout Song, currentSection: inout Sections, line: inout Line) {
        func processLines(textLines: [String]) {
            for var textLine in textLines {
                
                var chordLine = String()
                
                while let match = RegularExpression.chordPattern.firstMatch(in: textLine, options: [], range: textLine.range()) {
                    
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
                    //                    attrStr.append(.init(chordLine.newLine, foreGroundColor: UIColor.systemRed))
                }
                if !textLine.isWhitespace {
                    line.lyricsLine = textLine.newLine
                    //                    attrStr.append(.init(textLine.newLine))
                }
                
                
                
                //                var chords = chordLine.words()
                //                var lyrics = textLine.words()
                //
                //                while chords.count < lyrics.count {
                //                    chords.append(" ")
                //                }
                //                while lyrics.count < chords.count {
                //                    lyrics.append(" ")
                //                }
                //                print(textLine.words())
                //                zip(chordLine.words(), textLine.words()).forEach { c, l in
                //                    let part = Part()
                //                    part.chord = c
                //                    part.lyric = l
                //                    print(part.chord, part.lyric)
                //                    line.parts.append(part)
                //                }
                
            }
        }
        processLines(textLines: text.lines())
    }
    // MARK: - func: processChord; find key and suffix
    private static func processChord(chord: String) -> (key: Chords.Key, suffix: Chords.Suffix) {
        
        var key: Chords.Key = .c
        var suffix: Chords.Suffix = .major
        
        
        
        let chordRegex = try? NSRegularExpression(pattern: "([CDEFGABb#]+)(.*)")
        if let match = chordRegex?.firstMatch(in: chord, options: [], range: NSRange(location: 0, length: chord.utf16.count)) {
            if let keyRange = Range(match.range(at: 1), in: chord) {
                var valueKey = chord[keyRange].trimmingCharacters(in: .newlines)
                /// Dirty, some chords in the database are only in the flat version....
                if valueKey == "G#" {
                    valueKey = "Ab"
                }
                key = Chords.Key(rawValue: valueKey) ?? Chords.Key.c
            }
            if let valueRange = Range(match.range(at: 2), in: chord) {
                /// ChordPro suffix are not always the suffixes in the database...
                var suffixString = "major"
                switch chord[valueRange] {
                case "m":
                    suffixString = "minor"
                default:
                    suffixString = String(chord[valueRange])
                }
                suffix = Chords.Suffix(rawValue: suffixString.trimmingCharacters(in: .newlines)) ?? Chords.Suffix.major
            } else {
                suffix = Chords.Suffix.major
            }
        }
        return (key, suffix)
    }
    
}
