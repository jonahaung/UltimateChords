//
//  Instrument.swift
//  
//
//  Created by Aung Ko Min on 12/12/2021.
//

import Foundation


public struct Instrument: Decodable, Hashable {
    public let name: String
    public let keys: [String]
    public let suffixes: [String]
    public let chords: [String: [Instrument.Chord]]
}


extension Instrument {
    
    public struct Chord: Hashable, Equatable, Decodable {
        let key: String
        let suffix: String
        let positions: [Position]
        
        public struct Position: Hashable, Equatable, Decodable {
            let baseFret: Int
            let barres: [Int]
            let frets: [Int]
            let fingers: [Int]
        }
    }
}

extension Instrument {
    public static let guitar = instrument(from: "guitar")
    public static let ukulele = instrument(from: "ukulele")
    
    public func findChordPositions(key: String, suffix: String) -> [Chord.Position] {
        chords[key]?.first(where: { $0.suffix == suffix })?.positions ?? []
    }
    
    static func instrument(from resource: String) -> Instrument {
        #if SWIFT_PACKAGE
        let url = Bundle.module.url(forResource: resource, withExtension: "json")
        #else
        let url = Bundle(for: BundleToken.self).url(forResource: resource, withExtension: "json")
        #endif
        let data = try! Data(contentsOf: url!)
        return try! JSONDecoder().decode(Instrument.self, from: data)
    }
}

private class BundleToken {}
