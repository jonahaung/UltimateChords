// MARK: - struct: the chords in the song

import Foundation
import SwiftyChords

struct Chord: Identifiable {
    var id = UUID()
    var name: String
    var key: Chords.Key
    var suffix: Chords.Suffix
    var define: String
    var basefret: Int {
        return Int(define.prefix(1)) ?? 1
    }
}
