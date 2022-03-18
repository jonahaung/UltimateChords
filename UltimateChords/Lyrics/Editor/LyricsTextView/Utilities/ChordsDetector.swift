//
//  ChordsDetector.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 18/3/22.
//

import Foundation

protocol TagDetection {
    func detectTags(from string: String, with regx: NSRegularExpression) -> [DPTag]
}

extension TagDetection {
    
    func detectTags(from string: String, with regx: NSRegularExpression) -> [DPTag] {
        let nsString = string as NSString
        var tags = [DPTag]()
        regx.enumerateMatches(in: string, options: [], range: nsString.range()) { result, matches, pointer in
            if let result = result {
                let subRange = result.range
                let subString = nsString.substring(with: subRange)
                let tag = DPTag(name: subString, range: subRange)
                tags.append(tag)
                
            }
        }
        return tags
    }
}
