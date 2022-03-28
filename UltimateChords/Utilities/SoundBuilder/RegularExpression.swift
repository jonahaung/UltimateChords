//
//  RegularExpression.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 18/3/22.
//

import Foundation

enum RegularExpression {
   
    static let chordPattern: NSRegularExpression = {
        do {
            return try NSRegularExpression(pattern: "\\[(.*?)\\]", options: [])
        }catch {
            fatalError()
        }
    }()
    static let chordPattern2: NSRegularExpression = {
        do {
            return try NSRegularExpression(pattern: "\\[\\w+?\\]", options: [])
        }catch {
            fatalError()
        }
    }()
    
    static let lyricsPattern: NSRegularExpression = {
        do {
            return try NSRegularExpression(pattern: "(\\[[\\w#b/]+])?([^\\[]*)", options: .caseInsensitive)
        }catch {
            fatalError()
        }
    }()
    
    static let directivePattern: NSRegularExpression = {
        do {
            return try NSRegularExpression(pattern: "\\{(\\w*):([^%]*)\\}", options: [])
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
