// MARK: - class: a part of a line of the song

import Foundation

class Part: Identifiable {
    
    var id = UUID()
    var chord: String?
    var lyric: String?
    
    var empty: Bool {
        return (chord ?? "").isEmpty && (lyric ?? "").isEmpty
    }
}
