//
//  XApp.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 25/3/22.
//

import UIKit

struct XApp {

    
    static func calculateMaxCharacters() -> Int {
        let font = UIFont.monospacedSystemFont(ofSize: UIFont.labelFontSize, weight: .medium)
        func getWidth(for chSize: Int) -> Int {
            var text = String()
            (1..<chSize).forEach { _ in
                text += "-"
            }
            
            if text.size(OfFont: font).width + 50 >= UIScreen.main.bounds.size.width {
                return getWidth(for: chSize - 1)
            }
            return chSize
        }
       return getWidth(for: 100) + 16
    }
}
