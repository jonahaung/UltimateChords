//
//  +String.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 18/3/22.
//

import Foundation

extension String {
    
    func lines() -> [String] {
        components(separatedBy: .newlines)
    }
    
    func words() -> [String] {
        components(separatedBy: .whitespacesAndNewlines)
    }
    
    func trimmed() -> String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func range() -> NSRange {
        (self as NSString).range()
    }
}

extension NSString {
    func range() -> NSRange {
        NSRange(location: 0, length: length)
    }
}
