// MARK: - class: sections of the song

import Foundation

class Sections: Identifiable {
    
    var id = UUID()
    var name: String?
    var type: String?
    var lines = [Line]()
    
    var sectionKind = SectionKind.Text
    
    enum SectionKind {
        case Tab, Cho, Verse, Text, Comments
    }
}
