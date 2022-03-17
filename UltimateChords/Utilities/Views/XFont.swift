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
    enum Condense: String {
        case SemiCondensed, Condensed, ExtraCondensed
    }
    enum Weight: String {
        case Light, Regular, Medium, SemiBold, Bold
    }
    // MARK: - Constants
    
    private struct Constants {
        static let name = "NotoSansMono"
    }
    
    // MARK: - Methods
    
    static func font(condense: Condense? = .ExtraCondensed, weight: Weight = .Regular, size: Size = .System) -> Font {
        Font.custom(Constants.name + (condense?.rawValue ?? "") + "-" + weight.rawValue, size: size.rawValue)
    }
    static func uiFont(condense: Condense? = .ExtraCondensed, weight: Weight = .Regular, size: Size = .System) -> UIFont {
        return .init(name: Constants.name + (condense?.rawValue ?? "") + "-" + weight.rawValue, size: size.rawValue)!
    }
}

