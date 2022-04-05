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

    internal var displayMode = DisplayMode.Default
}

extension Song {
    
    enum DisplayMode: String, CaseIterable {
        case Default, Copyable, Editing, TextOnly
        func next() -> DisplayMode {
            switch self {
            case .Default:
                return .Copyable
            case .Copyable:
                return .Editing
            case .Editing:
                return .TextOnly
            case .TextOnly:
                return .Default
            }
        }
    }
    
    var attributedText: NSAttributedString {
        AttributedString.displayText(for: self, with: displayMode)
    }

    mutating func setDisplayMode(_ newValue: DisplayMode) {
        self.displayMode = newValue
    }

}
