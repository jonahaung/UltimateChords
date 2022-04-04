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
    static let chordPattern3: NSRegularExpression = {
        do {
            return try NSRegularExpression(pattern: "([CDEFGABb#]+)(.*)", options: .caseInsensitive)
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
    
    static let directiveEmptyRegex: NSRegularExpression = {
        do {
            return try NSRegularExpression(pattern: "\\{(\\w*)\\}", options: .caseInsensitive)
        }catch {
            fatalError()
        }
    }()
    
    static let lyricsRegex: NSRegularExpression = {
        do {
            return try NSRegularExpression(pattern: "(\\[[\\w#b/]+])?([^\\[]*)", options: .caseInsensitive)
        }catch {
            fatalError()
        }
    }()
    
    static let defineRegex = try! NSRegularExpression(pattern: "([a-z0-9#b/]+)(.*)", options: .caseInsensitive)
    static let measuresRegex = try! NSRegularExpression(pattern: "([\\[[\\w#b\\/]+\\]\\s]+)[|]*", options: .caseInsensitive)
    static let chordsRegex = try! NSRegularExpression(pattern: "\\[([\\w#b\\/]+)\\]?", options: .caseInsensitive)
    
}

extension NSRegularExpression {

    func stringByReplacingMatches(in string: String, withTemplate template: String) -> String {
        let r = NSRange(string.startIndex..<string.endIndex, in: string)
        return self.stringByReplacingMatches(in: string, options: [], range: r, withTemplate: template)
    }
    
}
