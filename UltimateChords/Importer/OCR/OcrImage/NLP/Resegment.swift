//
//  Resegmanent.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 19/4/22.
//

import Foundation

struct Resegment {
    
    static func myanmar(_ line : String) -> [String] {
        
        let outputs  =  RegularExpression.myanmarPattern.stringByReplacingMatches(in: line, withTemplate: "𝕊$1")
        let ouputArray = outputs.components(separatedBy: "𝕊")
        return ouputArray
    }

}
