//
//  TextAttributes.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 24/3/22.
//

import UIKit

extension NSAttributedString {
    
    convenience init(_ string: String, style: XFont.Style = .body, foreGroundColor: UIColor = .label) {
        let font: UIFont
        switch style {
        case .title:
            font = XFont.title(for: string)
        case .footnote:
            font = XFont.footnote(for: string)
        case .subheadline:
            font = XFont.subheadline(for: string)
        case .body:
            font = XFont.body(for: string)
        case .headline:
            font = XFont.headline(for: string)
        }
        self.init(string: string, attributes: [.font: font, .foregroundColor: foreGroundColor])
    }
}

extension NSAttributedString {
    
    var mutable: NSMutableAttributedString { NSMutableAttributedString(attributedString: self) }
    var attributes: [NSMutableAttributedString.Key: Any] { self.attributes(at: 0, effectiveRange: nil) }
    
    func size(for largestSize: CGSize) -> CGSize {
        let framesetter = CTFramesetterCreateWithAttributedString(self)
        return CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRange(), nil, largestSize, nil)
    }
}
