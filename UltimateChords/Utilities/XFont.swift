//
//  XFont.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 17/3/22.
//

import SwiftUI

struct XFont {

    // MARK: - Size
    
    enum Size {
        
        case LargeTitle, Title, Button, Label, System, Small
        case custom(CGFloat)
        
        var rawValue: CGFloat {
            switch self {
            case .LargeTitle:
                return UIFont.preferredFont(forTextStyle: .largeTitle).pointSize
            case .Title:
                return UIFont.preferredFont(forTextStyle: .title1).pointSize
            case .Button:
                return UIFont.buttonFontSize
            case .Label:
                return UIFont.labelFontSize
            case .System:
                return UIFont.systemFontSize
            case .Small:
                return UIFont.smallSystemFontSize
            case .custom(let cGFloat):
                return cGFloat
            }
        }
    }

    enum Weight: String {
        case Thin, ExtraLight, Light, Regular, Medium, SemiBold, Bold, ExtraBold, Black
    }
    // MARK: - Constants
    
    private struct Constants {
        static let name = "NotoSansMonoExtraCondensed"
    }
    
    // MARK: - Methods
    
    static func font(_ weight: Weight = .Regular, _ size: Size = .System) -> Font {
        Font.custom(Constants.name + "-" + weight.rawValue, size: size.rawValue)
    }
    static func uiFont(_ weight: Weight = .Medium, _ size: Size = .System) -> UIFont {
        return .init(name: Constants.name + "-" + weight.rawValue, size: size.rawValue)!
    }
}

