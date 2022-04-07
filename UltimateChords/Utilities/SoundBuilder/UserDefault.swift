//
//  UserDefault.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 4/4/22.
//

import Foundation

struct UserDefault {
    
    private static let manager = UserDefaults.standard
    
    struct LyricViewer {
        static let modelName = "\(LyricViewer.self)"
        
        enum DisplayMode: String, CaseIterable {
            case Default, Copyable, Editing, TextOnly
        }
        
        private static let _showChords = modelName + "showChords"
        private static let _isDinamicFontSizeEnabled = modelName + "isDinamicFontSizeEnabled"
        private static let _displayMode = modelName + "displayMode"
        
        static var isDinamicFontSizeEnabled: Bool {
            get { manager.bool(forKey: LyricViewer._isDinamicFontSizeEnabled) }
            set { manager.set(newValue, forKey: LyricViewer._isDinamicFontSizeEnabled)}
        }
        
        static var showChords: Bool {
            get { manager.bool(forKey: _showChords) }
            set { manager.set(newValue, forKey: _showChords)}
        }
        
        static var displayMode: DisplayMode {
            get { DisplayMode(rawValue: manager.string(forKey: _displayMode) ?? DisplayMode.Default.rawValue) ?? .Default }
            set { manager.set(newValue.rawValue, forKey: _displayMode)}
        }
    }

}
