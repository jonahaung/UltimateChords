//
//  TextView.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 27/3/22.
//

import UIKit

class TextView: UITextView {

    private var chordTags = [ChordTag]()
    
    init() {
        super.init(frame: .zero, textContainer: nil)
        textContainerInset = .zero
        textContainer.lineFragmentPadding = XApp.TextView.lineFragmentPadding
        showsVerticalScrollIndicator = false
        dataDetectorTypes = []
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
//    func applyTags(_ tags: [ChordTag]?) {
//        guard let tags = tags else {
//            return
//        }
//        
//        let mutableText = attributedText.mutable
//        chordTags.forEach { tag in
//            mutableText.addAttributes(tag.customTextAttributes, range: tag.range)
//        }
//        attributedText = mutableText
//        chordTags = tags
//    }
}
