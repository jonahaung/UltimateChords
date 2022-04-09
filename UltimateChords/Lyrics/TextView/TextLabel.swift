//
//  TextLabel.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 9/4/22.
//

import UIKit
import SwiftUI

class TextLabel: UILabel {

    private var chordTags = [ChordTag]()
    
  
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private var isDinamicFontSizeEnabled: Binding<Bool>
    
    init(_ isDinamicFontSizeEnabled: Binding<Bool>) {
        self.isDinamicFontSizeEnabled = isDinamicFontSizeEnabled
        super.init(frame: .zero)
        adjustsFontSizeToFitWidth = true
        numberOfLines = 0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        adjustFontSizeIfNeeded()
    }
    
    private func adjustFontSizeIfNeeded() {
        if isDinamicFontSizeEnabled.wrappedValue {
            adjustByDecreasingFontSize()
        }
    }
    private func adjustByDecreasingFontSize() {
        let mutable = attributedText?.mutable
        let containerSize = UIScreen.main.bounds.size
        mutable?.adjustFontSize(to: containerSize.width)
        self.attributedText = mutable
    }
}
