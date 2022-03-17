//
//  DPTagTextView.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 17/3/22.
//

import UIKit
import Combine
import SwiftUI

// MARK: - DPTag
public struct DPTag {
    public var id : String = UUID().uuidString
    public var name : String
    public var range: NSRange
    public var data : [String: Any] = [:]
    public var isHashTag: Bool = false
    public var customTextAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.systemRed]
}

// MARK: - DPTagTextViewDelegate
public protocol DPTagTextViewDelegate {
    func dpTagTextView(_ textView: DPTagTextView, didChangedTagSearchString strSearch: String, isHashTag: Bool)
    func dpTagTextView(_ textView: DPTagTextView, didInsertTag tag: DPTag)
    func dpTagTextView(_ textView: DPTagTextView, didRemoveTag tag: DPTag)
    func dpTagTextView(_ textView: DPTagTextView, didSelectTag tag: DPTag)
    func dpTagTextView(_ textView: DPTagTextView, didChangedTags arrTags: [DPTag])
    
    func textViewShouldBeginEditing(_ textView: DPTagTextView) -> Bool
    func textViewShouldEndEditing(_ textView: DPTagTextView) -> Bool
    func textViewDidBeginEditing(_ textView: DPTagTextView)
    func textViewDidEndEditing(_ textView: DPTagTextView)
    func textView(_ textView: DPTagTextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    func textViewDidChange(_ textView: DPTagTextView)
    func textViewDidChangeSelection(_ textView: DPTagTextView)
    func textView(_ textView: DPTagTextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool
    func textView(_ textView: DPTagTextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool
}

public extension DPTagTextViewDelegate {
    func dpTagTextView(_ textView: DPTagTextView, didChangedTagSearchString strSearch: String, isHashTag: Bool) {}
    func dpTagTextView(_ textView: DPTagTextView, didInsertTag tag: DPTag) {}
    func dpTagTextView(_ textView: DPTagTextView, didRemoveTag tag: DPTag) {}
    func dpTagTextView(_ textView: DPTagTextView, didSelectTag tag: DPTag) {}
    func dpTagTextView(_ textView: DPTagTextView, didChangedTags arrTags: [DPTag]) {}
    
    func textViewShouldBeginEditing(_ textView: DPTagTextView) -> Bool { true }
    func textViewShouldEndEditing(_ textView: DPTagTextView) -> Bool { true }
    func textViewDidBeginEditing(_ textView: DPTagTextView) {}
    func textViewDidEndEditing(_ textView: DPTagTextView) {}
    func textView(_ textView: DPTagTextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool { true }
    func textViewDidChange(_ textView: DPTagTextView) {}
    func textViewDidChangeSelection(_ textView: DPTagTextView) {}
    func textView(_ textView: DPTagTextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool { true }
    func textView(_ textView: DPTagTextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool { true }
}


open class DPTagTextView: UITextView {
    
    // MARK: - Properties
    open var mentionSymbol: String = "@"
    open var hashTagSymbol: String = "#"
    
    private let paragraphStyle: NSMutableParagraphStyle = {
        $0.lineBreakMode = .byClipping
//        $0.lineHeightMultiple = 2
        return $0
    }(NSMutableParagraphStyle())
    open var textViewAttributes: [NSAttributedString.Key: Any] = {
        [.font: XFont.uiFont(condense: .ExtraCondensed, weight: .Medium, size: .custom(15))]
    }()
    
    open var mentionTagTextAttributes: [NSAttributedString.Key: Any] = {
        [.foregroundColor: UIColor.systemBlue]
    }()
    
    open var hashTagTextAttributes: [NSAttributedString.Key: Any] = {
        [.foregroundColor: UIColor.systemRed]
    }()
    
    public private(set) var arrTags : [DPTag] = []
    open var dpTagDelegate : DPTagTextViewDelegate?
    open var allowsHashTagUsingSpace : Bool = true
    
    
    private var currentTaggingRange: NSRange?
    private var currentTaggingText: String? {
        didSet {
            if let tag = currentTaggingText, tag != oldValue {
                dpTagDelegate?.dpTagTextView(self, didChangedTagSearchString:tag, isHashTag: isHashTag)
            }
        }
    }
    
    private var tagRegex: NSRegularExpression {
        try! NSRegularExpression(pattern: "(\(mentionSymbol)|\(hashTagSymbol))([^\\s\\K]+)")
    }
    private var isHashTag = false
    private var tapGesture = UITapGestureRecognizer()
    
    public init() {
        super.init(frame: .zero, textContainer: nil)
        setup()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override var isEditable: Bool {
        didSet {
            guard oldValue != isEditable else { return }
            if isEditable {
                becomeFirstResponder()
            }
        }
    }
    open var isDetectable: Bool = false {
        didSet {
            guard oldValue != isDetectable else { return }
            setTagDetection(isDetectable)
        }
    }
}

// MARK: - Public methods
public extension DPTagTextView {
    
    
    func addTag(allText: String? = nil, tagText: String, id: String = UUID().uuidString, data : [String:Any] = [:], isAppendSpace: Bool = true) {
        guard let range = currentTaggingRange else { return }
        guard let allText = (allText == nil ? text : allText) else { return }
        
        let origin = (allText as NSString).substring(with: range)
        let tag = isHashTag ? hashTagSymbol.appending(tagText) : tagText
        let replace = isAppendSpace ? tag.appending(" ") : tag
        let changed = (allText as NSString).replacingCharacters(in: range, with: replace)
        let tagRange = NSMakeRange(range.location, tag.utf16.count)
        
        let dpTag = DPTag(id: id, name: tagText, range: tagRange, data: data, isHashTag: isHashTag)
        arrTags.append(dpTag)
        for i in 0..<arrTags.count-1 {
            var location = arrTags[i].range.location
            let length = arrTags[i].range.length
            if location > tagRange.location {
                location += replace.utf16.count - origin.utf16.count
                arrTags[i].range = NSMakeRange(location, length)
            }
        }
        
        text = changed
        updateAttributeText(selectedLocation: range.location+replace.utf16.count)
        dpTagDelegate?.dpTagTextView(self, didInsertTag: dpTag)
        dpTagDelegate?.dpTagTextView(self, didChangedTags: arrTags)
        isHashTag = false
        
    }
    
    private func setTagDetection(_ isTagDetection : Bool) {
        self.removeGestureRecognizer(tapGesture)
        if isTagDetection {
            tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnTextView(_:)))
            tapGesture.delegate = self
            self.addGestureRecognizer(tapGesture)
        }
    }
    
    func setLyricsData(_ data: LyricsData) {
        self.text = data.text
        self.arrTags = data.tags
        updateAttributeText(selectedLocation: -1)
    }
//    open override func layoutSubviews() {
//        super.layoutSubviews()
//        displayChords()
//    }
//    private func displayChords() {
//        displayedLayers.forEach {
//            $0.removeFromSuperlayer()
//        }
//        displayedLayers.removeAll()
//        arrTags.forEach { tag in
//            let range = tag.range
//            let beginning: UITextPosition = self.beginningOfDocument
//            let start: UITextPosition? = self.position(from: beginning, offset: range.location)
//            let end: UITextPosition? = self.position(from: start!, offset: range.length)
//            let textRange: UITextRange? = self.textRange(from: start!, to: end!)
//            let rect: CGRect = self.firstRect(for: textRange!)
//            let layer = CATextLayer()
//            layer.contentsScale = UIScreen.main.scale
//            layer.isWrapped = true
//            layer.font = XFont.uiFont(condense: .ExtraCondensed, weight: .Medium, size: .Label)
//            layer.fontSize = UIFont.labelFontSize
//            layer.foregroundColor = UIColor.systemRed.cgColor
//            layer.string = tag.name
//            layer.frame = rect
//            self.displayedLayers.append(layer)
//            self.layer.addSublayer(layer)
//            
//        }
//    }
}


// MARK: - Private methods
extension DPTagTextView {
    
    func setup() {
        delegate = self
        enableCustomMenu()
    }
    func enableCustomMenu() {
        let addHash = UIMenuItem(title: "Add Chord", action: #selector(addChord))
        UIMenuController.shared.menuItems = [addHash]
    }
    
    
    
    @objc func addChord() {
        if let selected = selectedTextRange, let text = text(in: selected) {
            
            let tag = DPTag(name: text, range: selectedRange, data: ["note": "G"], isHashTag: true)
            self.arrTags = self.arrTags + [tag]
            updateAttributeText(selectedLocation: -1)
        }
        
    }
    
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(addChord) {
            return super.canPerformAction(action, withSender: sender)
        }
        return isEditable && super.canPerformAction(action, withSender: sender)
    }
    @objc final func tapOnTextView(_ recognizer: UITapGestureRecognizer) {
        
        guard let textView = recognizer.view as? UITextView else {
            return
        }
        
        var location: CGPoint = recognizer.location(in: textView)
        location.x -= textView.textContainerInset.left
        location.y -= textView.textContainerInset.top
        
        let charIndex = textView.layoutManager.characterIndex(for: location, in: textView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        guard charIndex < textView.textStorage.length - 1 else {
            return
        }
        
        for i in 0 ..< arrTags.count {
            if arrTags[i].range.location <= charIndex && arrTags[i].range.location+arrTags[i].range.length > charIndex {
                dpTagDelegate?.dpTagTextView(self, didSelectTag: arrTags[i])
            }
        }
    }
    
    private func matchedData(taggingCharacters: [Character], selectedLocation: Int, taggingText: String) -> (NSRange?, String?) {
        var matchedRange: NSRange?
        var matchedString: String?
        let tag = String(taggingCharacters.reversed())
        let textRange = NSMakeRange(selectedLocation-tag.utf16.count, tag.utf16.count)
        
        guard tag == mentionSymbol || tag == hashTagSymbol  else {
            let matched = tagRegex.matches(in: taggingText, options: .reportCompletion, range: textRange)
            if matched.count > 0, let range = matched.last?.range {
                matchedRange = range
                matchedString = (taggingText as NSString).substring(with: range).replacingOccurrences(of: isHashTag ? hashTagSymbol : mentionSymbol, with: "")
            }
            return (matchedRange, matchedString)
        }
        
        matchedRange = nil//textRange
        matchedString = nil//isHashTag ? hashTag : symbol
        return (matchedRange, matchedString)
    }
    
    private func tagging(textView: UITextView) {
        let selectedLocation = textView.selectedRange.location
        let taggingText = (textView.text as NSString).substring(with: NSMakeRange(0, selectedLocation))
        let space: Character = " "
        let lineBrak: Character = "\n"
        var tagable: Bool = false
        var characters: [Character] = []
        
        for char in Array(taggingText).reversed() {
            if char == mentionSymbol.first {
                characters.append(char)
                isHashTag = false
                tagable = true
                break
            } else if char == hashTagSymbol.first {
                characters.append(char)
                isHashTag = true
                tagable = true
                break
            }
            else if char == space || char == lineBrak {
                tagable = false
                break
            }
            characters.append(char)
        }
        
        guard tagable else {
            currentTaggingRange = nil
            currentTaggingText = nil
            return
        }
        
        let data = matchedData(taggingCharacters: characters, selectedLocation: selectedLocation, taggingText: taggingText)
        currentTaggingRange = data.0
        currentTaggingText = data.1
    }
    
    func updateAttributeText(selectedLocation: Int) {
        let attributedString = NSMutableAttributedString(string: text)
        textViewAttributes[.paragraphStyle] = self.paragraphStyle
        attributedString.addAttributes(textViewAttributes, range: NSMakeRange(0, text.utf16.count))
        arrTags.forEach { (dpTag) in
            attributedString.addAttributes(dpTag.customTextAttributes, range: dpTag.range)
        }
        
        attributedText = attributedString
        if selectedLocation > 0 { selectedRange = NSMakeRange(selectedLocation, 0) }
    }
    
    func updateArrTags(range: NSRange, textCount: Int) {
        arrTags = arrTags.filter({ (dpTag) -> Bool in
            if dpTag.range.location < range.location && range.location < dpTag.range.location+dpTag.range.length {
                dpTagDelegate?.dpTagTextView(self, didRemoveTag: dpTag)
                return false
            }
            if range.length > 0 {
                if range.location <= dpTag.range.location && dpTag.range.location < range.location+range.length {
                    dpTagDelegate?.dpTagTextView(self, didRemoveTag: dpTag)
                    return false
                }
            }
            return true
        })
        
        for i in 0 ..< arrTags.count {
            var location = arrTags[i].range.location
            let length = arrTags[i].range.length
            if location >= range.location {
                if range.length > 0 {
                    if textCount > 1 {
                        location += textCount - range.length
                    } else {
                        location -= range.length
                    }
                } else {
                    location += textCount
                }
                arrTags[i].range = NSMakeRange(location, length)
            }
        }
        
        currentTaggingText = nil
        dpTagDelegate?.dpTagTextView(self, didChangedTags: arrTags)
    }
    
    func addHashTagWithSpace(_ replacementText: String, _ range: NSRange) {
        if isHashTag && replacementText == " " && allowsHashTagUsingSpace {
            let selectedLocation = selectedRange.location
            let newText = (text as NSString).replacingCharacters(in: range, with: replacementText)
            let taggingText = (newText as NSString).substring(with: NSMakeRange(0, selectedLocation + 1))
            if let tag = taggingText.sliceMultipleTimes(from: "#", to: " ").last {
                addTag(allText: newText, tagText: tag, isAppendSpace: false)
            }
        }
    }
    
}

// MARK: - UITextViewDelegate
extension DPTagTextView: UITextViewDelegate {
    
    public func textViewDidChange(_ textView: UITextView) {

        tagging(textView: textView)
        updateAttributeText(selectedLocation: textView.selectedRange.location)
        dpTagDelegate?.textViewDidChange(self)
    }
    
    public func textViewDidChangeSelection(_ textView: UITextView) {
        tagging(textView: textView)
        dpTagDelegate?.textViewDidChangeSelection(self)
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        addHashTagWithSpace(text, range)
        updateArrTags(range: range, textCount: text.utf16.count)
        return dpTagDelegate?.textView(self, shouldChangeTextIn: range, replacementText: text) ?? true
    }
    
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        dpTagDelegate?.textViewShouldBeginEditing(self) ?? true
    }
    
    public func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        dpTagDelegate?.textViewShouldEndEditing(self) ?? true
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        dpTagDelegate?.textViewDidBeginEditing(self)
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        dpTagDelegate?.textViewDidEndEditing(self)
    }
    
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        dpTagDelegate?.textView(self, shouldInteractWith: URL, in: characterRange, interaction: interaction) ?? true
    }
    
    public func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        dpTagDelegate?.textView(self, shouldInteractWith: textAttachment, in: characterRange, interaction: interaction) ?? true
    }
    
}

// MARK: - UIGestureRecognizerDelegate
extension DPTagTextView : UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: - String extension
internal extension String {
    func sliceMultipleTimes(from: String, to: String) -> [String] {
        components(separatedBy: from).dropFirst().compactMap { sub in
            (sub.range(of: to)?.lowerBound).flatMap { endRange in
                String(sub[sub.startIndex ..< endRange])
            }
        }
    }
}
