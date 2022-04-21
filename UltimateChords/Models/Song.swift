// MARK: - class: the song

import Foundation

struct Song: Identifiable {
    
    var id = UUID()
    var title: String?
    var artist: String?
    var capo: String?
    var key: String?
    var tempo: String?
    var time: String?
    var year: String?
    var album: String?
    var tuning: String?
    var path: URL?
    var musicpath: URL?
    var custom = [String: String]()
    var sections = [Sections]()
    var chords = [Chord]()
    
    internal var rawText: String
    
    init(rawText: String) {
        self.rawText = rawText
    }
}


extension Song {
    
    mutating func transport(to toStr: String) {
        
        guard
            let fromChord = Chord.chord(for: self.key.str),
            let toChord = Chord.chord(for: toStr),
            let from = Key(fromChord.key.rawValue),
            let to = Key(toChord.key.rawValue) else { return }
        
        sections.forEach { section in
            section.lines.forEach { line in
                if var chordline = line.chordLine {
                    chordline.words().forEach { word in
                        if let transport = Note(word)?.transpose(from: from, to: to) {
                            chordline = chordline.replacingOccurrences(of: word, with: transport.name)
                        }
                    }
                    line.chordLine = chordline
                }
            }
        }
        self.key = toStr
    }
}

extension Song {
    
    var lyric: Lyric {
        .init(id: self.id.uuidString, title: self.title.str, artist: self.artist.str, key: self.key.str, text: self.rawText, composer: "", album: self.album.str, year: self.year.str, genre: "", version: 0)
    }
}
