//
//  UserDefault.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 4/4/22.
//

import Foundation

struct UserDefault {
    
    static let isDinamicFontSizeEnabled_ = "isDinamicFontSizeEnabled"
    
    static var isDinamicFontSizeEnabled: Bool {
        get {
            UserDefaults.standard.bool(forKey: isDinamicFontSizeEnabled_)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: isDinamicFontSizeEnabled_)
        }
    }
    
}
