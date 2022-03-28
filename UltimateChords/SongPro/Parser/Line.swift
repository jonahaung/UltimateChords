// MARK: - class: one line of the song

import Foundation

class Line: Identifiable {
    var id = UUID()
    var parts = [Part]()
    var measures = [Measure]()
    var tablature: String?
    var comment: String?
    var plain: String?
    
    var chordLine: String?
    var lyricsLine: String?
}
