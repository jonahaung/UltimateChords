// MARK: - class: the song

import Foundation

class Song: Identifiable, ObservableObject {
    
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
    var rawText: String?
    var chords = [Chord]()
    
    public var html: String { Html.parse(from: self) }
    public lazy var attributedText: NSAttributedString = AttributedString.parse(from: self)
    var pdfData: Data { Pdf.data(from: attributedText) }
}
