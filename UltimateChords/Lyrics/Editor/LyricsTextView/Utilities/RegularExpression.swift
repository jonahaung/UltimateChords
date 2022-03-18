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
    
    let mensionAndHashPattern: NSRegularExpression = {
        do {
            return try NSRegularExpression(pattern: "(@|#)([^\\s\\K]+)")
        }catch {
            fatalError()
        }
    }()
}
