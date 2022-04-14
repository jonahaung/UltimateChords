//
//  TextView.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 27/3/22.
//

import UIKit

enum wordType{
    case hashtag   // #标示文本类型
    case mention   // @标示文本类型
}

class TextView: UITextView {
    
    init() {
        super.init(frame: .zero, textContainer: nil)
        commonInit()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func commonInit() {
//        textContainerInset = .zero
//        textContainer.lineFragmentPadding = XApp.TextView.lineFragmentPadding
        showsVerticalScrollIndicator = false
        dataDetectorTypes = []
        backgroundColor = .clear
        isScrollEnabled = true
        alwaysBounceVertical = true
        bounces = true
        textContainer.lineBreakMode = .byClipping
    }
    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesEnded(touches, with: event)
//        if let last = Array(touches).last {
//            onTouch(point: last.location(in: self))
//        }
//    }
//
//
//    private func onTouch(point: CGPoint) {
//
//        var wordString: String?
//        var char: NSAttributedString!
//        var word: NSAttributedString?
//
//        var isChord: AnyObject?
//
//        let charPosition = closestPosition(to: point)
//
//        guard let charRange = tokenizer.rangeEnclosingPosition(charPosition!, with: .character, inDirection: .init(rawValue: 1)) else {
//            return
//        }
//
//        let location = offset(from: beginningOfDocument, to: charRange.start)
//        let length = offset(from: charRange.start, to: charRange.end)
//        let attrRange = NSMakeRange(location, length)
//        char = attributedText.attributedSubstring(from: attrRange)
//
//        if char.string == " "{
//            return
//        }
//
//        isChord = char?.attribute(.chord, at: 0, longestEffectiveRange: nil, in: NSMakeRange(0, char!.length)) as AnyObject?
//
//
//        let wordRange = tokenizer.rangeEnclosingPosition(charPosition!, with: .word, inDirection: .init(rawValue: 1))
//
//        if wordRange != nil {
//            let wordLocation = offset(from: beginningOfDocument, to: wordRange!.start)
//            let wordLength = offset(from: wordRange!.start, to: wordRange!.end)
//            let wordAttrRange = NSMakeRange(wordLocation, wordLength)
//            word = attributedText.attributedSubstring(from: wordAttrRange)
//            wordString = word!.string
//        } else {
//            var modifiedPoint = point
//            modifiedPoint.x += 12
//            let modifiedPosition = closestPosition(to: modifiedPoint)
//            let modifedWordRange = tokenizer.rangeEnclosingPosition(modifiedPosition!, with: .word, inDirection: .init(rawValue: 1))
//            if modifedWordRange != nil{
//                let wordLocation = offset(from: beginningOfDocument, to: modifedWordRange!.start)
//                let wordLength = offset(from: modifedWordRange!.start, to: modifedWordRange!.end)
//                let wordAttrRange = NSMakeRange(wordLocation, wordLength)
//                word = attributedText.attributedSubstring(from: wordAttrRange)
//                wordString = word!.string
//            }
//        }
//
//        if let stringToPass = wordString {
//            if isChord != nil {
//                print(stringToPass)
//            }
//        }
//    }
}
