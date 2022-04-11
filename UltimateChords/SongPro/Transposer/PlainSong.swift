//
//  MusicSong.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 10/4/22.
//

import Foundation

typealias MusicTextComponents = String
typealias MusicLine = [MusicTextComponents]

class PlainSong: Equatable {
    
    init() {}
    init(_ text: String) {
        self.text = text
        self.lines = text.split(separator: "\n").map {String($0)}
    }
    
    static func == (lh: PlainSong, rh: PlainSong) -> Bool {
        return lh.text == rh.text
    }
    
    subscript(x: Int) -> String {
        return lines[x]
    }
    
    var lines = MusicLine()
    var text = String() {
        didSet {
            self.lines = text.split(separator: "\n").map {String($0)}
        }
    }
    
    func transposed(from sourceKey: MusicKey, to destKey: MusicKey) -> PlainSong {
        var newText = ""
        for line in self.lines {
            if line.isMusicLine_byCount {
                newText += line.transpose(from: sourceKey, to: destKey)
            } else {
                newText += line
            }
            if line != self.lines.last! { newText += "\n" }
        }
        return PlainSong(newText)
    }
    
    func transposed(fromString sourceKey: String, toString destKey: String) -> PlainSong? {
        guard let source = MusicKey(sourceKey), let dest = MusicKey(destKey) else { return nil }
        return self.transposed(from: source, to: dest)
    }
    
}
