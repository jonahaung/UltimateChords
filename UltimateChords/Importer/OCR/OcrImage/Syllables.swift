//
//  Syllables.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 19/4/22.
//

import Foundation

class Syllables {
    
    static let myanamrWords: [String] = {
        var items = [String]()
        if let url = Bundle.main.url(forResource: "syllables", withExtension: "txt") {
            do {
                let string = try String(contentsOf: url, encoding: .utf8)
                items = string.words()
            } catch {
                print(error)
            }
        }
        return items
    }()
    static let guitarChords: [String] = {
        Chord.allChords().map{$0.name}
    }()
}
