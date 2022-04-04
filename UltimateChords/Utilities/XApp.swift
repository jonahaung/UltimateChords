//
//  XApp.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 25/3/22.
//

import UIKit

struct XApp {
    struct PDF {
        struct A4 {
            static let size = CGSize(width: 595, height: 842)
            static let margin = UIEdgeInsets(top: 60, left: 30, bottom: 60, right: 30)
            static var availiableWidth: CGFloat { size.width - margin.left - margin.right }
            static var ratio: CGFloat { UIScreen.main.bounds.width / size.width }
        }
    }

    struct TextView {
        static let lineFragmentPadding = CGFloat(8)
    }
    
//    static func calculateMaxCharacters() -> Int {
//        let font = UIFont.monospacedSystemFont(ofSize: UIFont.labelFontSize, weight: .medium)
//        func getWidth(for chSize: Int) -> Int {
//            var text = String()
//            (1..<chSize).forEach { _ in
//                text += "-"
//            }
//            
//            if text.size(OfFont: font).width + 50 >= UIScreen.main.bounds.size.width {
//                return getWidth(for: chSize - 1)
//            }
//            return chSize
//        }
//       return getWidth(for: 100) + 16
//    }
}

extension String {
    
    func splitByLength(_ length: Int, seperator: String) -> [String] {
        var result = [String]()
        var collectedWords = [String]()
        collectedWords.reserveCapacity(length)
        var count = 0
        
        for word in self.components(separatedBy: seperator) {
            count += word.count + 1 //add 1 to include space
            if (count > length) {
                result.append(collectedWords.map { String($0) }.joined(separator: seperator) )
                collectedWords.removeAll(keepingCapacity: true)
                
                count = word.count
            }
            
            collectedWords.append(word)
        }
        
        // Append the remainder
        if !collectedWords.isEmpty {
            result.append(collectedWords.map { String($0) }.joined(separator: seperator))
        }
        
        return result
    }
}


extension String {
    func size(OfFont font: UIFont) -> CGSize {
        return (self as NSString).size(withAttributes: [NSAttributedString.Key.font: font])
    }
}
