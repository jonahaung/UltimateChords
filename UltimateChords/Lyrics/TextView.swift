//
//  TextView.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 27/3/22.
//

import UIKit

class TextView: UITextView {

    init() {
        super.init(frame: .zero, textContainer: nil)
        textContainerInset = .zero
        textContainer.lineFragmentPadding = 8
        showsVerticalScrollIndicator = false
        dataDetectorTypes = []
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
