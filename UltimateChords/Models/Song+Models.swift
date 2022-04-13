//
//  Song+Models.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 5/4/22.
//

import Foundation

extension Song {
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
    
    class Part: Identifiable {
        
        var id = UUID()
        var chord: String?
        var lyric: String?
        
        var empty: Bool {
            return (chord ?? "").isEmpty && (lyric ?? "").isEmpty
        }
    }
    
    class Measure: Identifiable {
        var id = UUID()
        var chords = [String]()
    }


}
