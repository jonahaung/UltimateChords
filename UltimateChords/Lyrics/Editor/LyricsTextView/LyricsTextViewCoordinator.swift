//
//  LyricsTextViewCoordinator.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 17/3/22.
//

import SwiftUI

class LyricsTextViewCoordinator: NSObject, ObservableObject {
    
    var setTagsBlock: (([DPTag]) -> Void)?
    var setAttributedTextBlock: ((NSAttributedString) -> Void)?
    
    @Published var htmlString: String?
    @Published var pdfData: Data?
    
    var attributedText: NSAttributedString
    
    @Published var isEditable = false
    @Published var fontSize = UIFont.smallSystemFontSize {
        didSet {
            textAttributes[.font] = (textAttributes[.font] as! UIFont).withSize(fontSize)
            let mutable = NSMutableAttributedString(attributedString: attributedText)
            mutable.addAttributes(textAttributes, range: NSRange(location: 0, length: mutable.length))
            setAttributedTextBlock?(mutable)
        }
    }
    
    private var textAttributes: [NSAttributedString.Key: Any] = [.font: XFont.uiFont(.Medium, .Small)]
    
    init(_ text: String) {
        attributedText = NSAttributedString(string: text, attributes: textAttributes)
    }
}

extension LyricsTextViewCoordinator: UITextViewDelegate {
    
}

extension LyricsTextViewCoordinator: TagDetection {
    
    func detect() {
        let tags = detectTags(from: attributedText.string, with: RegularExpression.shared.chordPattern)
        self.setTagsBlock?(tags)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.setTagsBlock?([])
        self.setAttributedTextBlock?(NSAttributedString(string: self.attributedText.string, attributes: textAttributes))
    }
    
    func makePDF() {
        if let url = Pdf.createPdf(from: attributedText) {
            
            pdfData = try? Data.init(contentsOf: url)
        }
        
    }
    func makeHtml() {
        htmlString = attributedText.toHtml()
    }
}
