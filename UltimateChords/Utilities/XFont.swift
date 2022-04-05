//
//  XFont.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 17/3/22.
//

import SwiftUI

struct XFont {

    enum MyanmarFont: String {
        case MyanmarSansPro, MyanmarAngoun, MyanmarSquare, MasterpieceSpringRev
    }
    enum Style {
        case title, headline, body, subheadline, footnote
    }
    
    // Automatic Fonts
    static func title(for text: String) -> UIFont {
        let isMyanmar = text.isMyanar
        let size = isMyanmar ? 40 : UIFont.preferredFont(forTextStyle: .title1).pointSize
        let fontName = isMyanmar ? MyanmarFont.MasterpieceSpringRev.rawValue : "NotoSansMonoExtraCondensed-Black"
        return UIFont(name: fontName, size: size)!
    }
    static func headline(for text: String) -> UIFont {
        let fontName = text.isMyanar ? MyanmarFont.MyanmarSquare.rawValue : "NotoSansMonoExtraCondensed-SemiBold"
        return .init(name: fontName, size: UIFont.buttonFontSize)!
    }
    static func subheadline(for text: String) -> UIFont {
        let fontName = text.isMyanar ? MyanmarFont.MyanmarAngoun.rawValue : "NotoSansMonoExtraCondensed-Regular"
        return UIFont(name: fontName, size: UIFont.systemFontSize)!
    }
    
    static func body(for text: String) -> UIFont {
        let fontName = text.isMyanar ? MyanmarFont.MyanmarAngoun.rawValue : "NotoSansMonoExtraCondensed-Medium"
        return UIFont(name: fontName, size: UIFont.labelFontSize)!
    }
    
    static func footnote(for text: String) -> UIFont {
        let fontName = text.isMyanar ? MyanmarFont.MyanmarSansPro.rawValue : "NotoSansMonoExtraCondensed-Regular"
        return .init(name: fontName, size: UIFont.systemFontSize)!
    }
    
    static func chord() -> UIFont {
        .init(name: "NotoSansMonoExtraCondensed-Medium", size: UIFont.labelFontSize)!
    }
}

extension String {
    
    var language: String { NSLinguisticTagger.dominantLanguage(for: self) ?? ""}
    
    var isMyanar: Bool { language == "my" }
}

extension UIFont {
    var font: Font {
        .init(self)
    }
}
