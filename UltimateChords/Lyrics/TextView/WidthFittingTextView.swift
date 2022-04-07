//
//  WidthFittingTextView.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 22/3/22.
//

import UIKit
import SwiftUI

class WidthFittingTextView: TextView {
    
    private var isDinamicFontSizeEnabled: Binding<Bool>
    
    init(_ isDinamicFontSizeEnabled: Binding<Bool>) {
        self.isDinamicFontSizeEnabled = isDinamicFontSizeEnabled
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        let mutable = attributedText.mutable
        let containerSize = UIScreen.main.bounds.size
        mutable.adjustFontSize(to: containerSize.width)
        self.attributedText = mutable
    }
    
}
