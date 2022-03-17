//
//  LyricsTextViewCoordinator.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 17/3/22.
//

import SwiftUI

class LyricsTextViewCoordinator: NSObject, ObservableObject {
    
    @Published var htmlString: String?
    @Published var pdfData: Data?
    
    @Published var attributedText: NSAttributedString
    
    @Published var isEditable = false
    @Published var fontSize = UIFont.smallSystemFontSize {
        didSet {
            textAttributes[.font] = (textAttributes[.font] as! UIFont).withSize(fontSize)
            let mutable = NSMutableAttributedString(attributedString: attributedText)
            mutable.addAttributes(textAttributes, range: NSRange(location: 0, length: mutable.length))
            attributedText = mutable
        }
    }
    
    @Published var suggesstedTags = [String]()
    private let mTagData : [String] = ["Jonah", "Aung Ko Min", "Jonah Aung", "Aung", "AKM", "Denis Tant"]
    private let hTagData : [String] = ["coding", "coding", "swift", "programming", "application", "app developer"]
    private var textAttributes: [NSAttributedString.Key: Any]
    
    init(_ text: String) {
        let paragraphStyle: NSMutableParagraphStyle = {
            $0.lineBreakMode = .byClipping
            return $0
        }(NSMutableParagraphStyle())
        textAttributes = [.paragraphStyle: paragraphStyle, .font: XFont.uiFont(condense: .ExtraCondensed, weight: .Medium, size: .Small)]
        attributedText = NSAttributedString(string: text, attributes: textAttributes)
    }
}

extension LyricsTextViewCoordinator: UITextViewDelegate {
    
}

extension LyricsTextViewCoordinator {
    
    func detect() {
        if let data = getLyricsData() {
            let attributedString = NSMutableAttributedString(string: data.text, attributes: self.textAttributes)
            data.tags.forEach { (dpTag) in
                attributedString.addAttributes(dpTag.customTextAttributes, range: dpTag.range)
            }
            
            attributedText = attributedString
        }
    }
    
    func getLyricsData() -> LyricsData? {
        
        do {
            let regex = try NSRegularExpression(pattern: "\\[(.*?)\\]", options: [])
            let nsString = self.attributedText.string as NSString
            
            var tags = [DPTag]()
            regex.enumerateMatches(in: self.attributedText.string, options: [], range: NSMakeRange(0, nsString.length)) { result, matches, pointer in
                guard let result = result else {
                    return
                }
                
                let subRange = result.range
                let subString = nsString.substring(with: subRange)
                
                let chord = subString.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "")
                
                let tag = DPTag(name: chord, range: subRange, data: ["chord": chord], isHashTag: false)
                tags.append(tag)
            }
            
            return .init(text: self.attributedText.string, tags: tags)
            
        } catch let error as NSError {
            
            print("invalid regex: \(error.localizedDescription)")
            return nil
            
        }
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
