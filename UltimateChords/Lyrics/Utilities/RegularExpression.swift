//
//  RegularExpression.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 18/3/22.
//

import Foundation

class RegularExpression {
    
    static let shared = RegularExpression()
    
    let chordPattern: NSRegularExpression = {
        do {
            return try NSRegularExpression(pattern: "\\[(.*?)\\]", options: [])
        }catch {
            fatalError()
        }
    }()
    let chordPattern2: NSRegularExpression = {
        do {
            return try NSRegularExpression(pattern: "\\[\\w+?\\]", options: [])
        }catch {
            fatalError()
        }
    }()
    
    let titlePattern: NSRegularExpression = {
        do {
            return try NSRegularExpression(pattern: "\\[t(.*?)\\]", options: [])
        }catch {
            fatalError()
        }
    }()
    let artistPattern: NSRegularExpression = {
        do {
            return try NSRegularExpression(pattern: "\\@artist=([^\\s\\K]+)", options: [])
        }catch {
            fatalError()
        }
    }()
    let mensionAndHashPattern: NSRegularExpression = {
        do {
            return try NSRegularExpression(pattern: "(@|#)([^\\s\\K]+)")
        }catch {
            fatalError()
        }
    }()
}

extension NSRegularExpression {

    func stringByReplacingMatches(in string: String, withTemplate template: String) -> String {
        let r = NSRange.init(string.startIndex..<string.endIndex, in: string)
        return self.stringByReplacingMatches(in: string, options: [], range: r, withTemplate: template)
    }
    
}
