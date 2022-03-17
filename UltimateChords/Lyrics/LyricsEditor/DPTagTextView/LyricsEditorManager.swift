//
//  TextViewTagsControl.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 17/3/22.
//

import SwiftUI

class LyricsEditorManager: NSObject, ObservableObject {
    
    var setLyricsDataBlock: ((LyricsData) -> Void)?
    var addTagBlock: ((String) -> Void)?
    var attributedString = NSAttributedString(string: DemoSongs.sweetChildOMine)
    
    @Published var htmlString: String?
    @Published var pdfData: Data?
    
    @Published var isEditable = false
    @Published var isSelectable = true
    @Published var isDetectable = true
    
    @Published var suggesstedTags = [String]()
    private let mTagData : [String] = ["Jonah", "Aung Ko Min", "Jonah Aung", "Aung", "AKM", "Denis Tant"]
    private let hTagData : [String] = ["coding", "coding", "swift", "programming", "application", "app developer"]
}

extension LyricsEditorManager {
    
    
    func makePDF() {
        if let url = Pdf.createPdf(from: attributedString) {
    
            pdfData = try? Data.init(contentsOf: url)
        }
        
    }
    func makeHtml() {
        htmlString = attributedString.toHtml()
    }
}
// From View
extension LyricsEditorManager {
    
    func addTag(_ text: String) {
        addTagBlock?(text)
        suggesstedTags.removeAll()
    }
    func detectChords() {
        if let data = attributedString.string.getLyricsData() {
            self.setLyricsDataBlock?(data)
        }
    }
}

extension LyricsEditorManager: DPTagTextViewDelegate {
    
    func dpTagTextView(_ textView: DPTagTextView, didInsertTag tag: DPTag) {
        print("inserted")
    }
    func dpTagTextView(_ textView: DPTagTextView, didRemoveTag tag: DPTag) {
        print("removed", tag)
    }
    func dpTagTextView(_ textView: DPTagTextView, didSelectTag tag: DPTag) {
        print("slect", tag)
    }
    func dpTagTextView(_ textView: DPTagTextView, didChangedTags arrTags: [DPTag]) {

    }
    
    func dpTagTextView(_ textView: DPTagTextView, didChangedTagSearchString strSearch: String, isHashTag: Bool) {
        suggesstedTags = (isHashTag ? hTagData : mTagData).filter{ $0.lowercased().contains(strSearch.lowercased())}
    }
    
    func textViewDidChangeSelection(_ textView: DPTagTextView) {
//        if textView.selectedRange.length > 0 {
//            let tag = DPTag(name: "Aung Ko Min", range: textView.selectedRange, data: ["note": "G"], isHashTag: true)
//            textView.arrTags.append(tag)
//            textView.updateAttributeText(selectedLocation: -1)
//        }
    }
   
    func textViewDidChange(_ textView: DPTagTextView) {
        attributedString = textView.attributedText
    }
}

extension String: Identifiable {
    public var id: String {
        self
    }
    
    func getLyricsData() -> LyricsData? {
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.blue]
        do {
            let regex = try NSRegularExpression(pattern: "\\[(.*?)\\]", options: [])
            let nsString = self as NSString
        
            var tags = [DPTag]()
            regex.enumerateMatches(in: self, options: [], range: NSMakeRange(0, nsString.length)) { result, matches, pointer in
                guard let result = result else {
                    return
                }

                let subRange = result.range
                let subString = nsString.substring(with: subRange)
            
                let chord = subString.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "")
                
                let tag = DPTag(name: chord, range: subRange, data: ["chord": chord], isHashTag: false, customTextAttributes: attributes)
                tags.append(tag)
            }
            
           return .init(text: self, tags: tags)
            
        } catch let error as NSError {
            
            print("invalid regex: \(error.localizedDescription)")
            return nil
    
        }
    }
}
