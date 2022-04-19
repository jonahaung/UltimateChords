//
//  TextReconizerImage.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 7/4/22.
//


import SwiftUI

class OCRImageViewModel: ObservableObject {
    
    @Published var hasChanges = true
    @Published var recognizingText = false
    @Published var text: String?

    private lazy var textRecognizer = TextRecognizer()
    private let image: UIImage
    weak var quadImageView: QuadImageView?
    
    init(image: UIImage) {
        self.image = image
    }
    
    deinit {
        print("Deinit: TextRecognizerImage")
    }
}

extension OCRImageViewModel {
    
    func task() {
        quadImageView?.updateImage(ImageFilterer.filter(for: image, with: .Adjust_Color))
    }
    
    func detextTexts() {
        func cropedImage() -> UIImage? {
            guard let quadImageView = quadImageView, let editedImage = quadImageView.imageView.image else { return nil }
            
            if let quad = quadImageView.quadView.viewQuad, let image = ImageFilterer.crop(image: editedImage, quad: quad, canvasSize: quadImageView.frame.size) {
                return image
            }
            return nil
        }
        
        if let uiImage = cropedImage() {
            self.recognizingText = true
            textRecognizer.detectTexts(from: ImageResizer(targetWidth: UIScreen.main.bounds.width).resize(image: uiImage)) { [weak self] string in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.recognizingText = false
                    let text = string.str
                    self.text = text
                }
            }
        }
    }
    
    func reset() {
        quadImageView?.updateImage(image)
        hasChanges = false
    }
    
    func filter(_ mode: ImageFilterMode) {
        guard let editedImage = quadImageView?.imageView.image else { return }
        quadImageView?.updateImage(ImageFilterer.filter(for: editedImage, with: mode))
        hasChanges = true
    }
}
struct Resegment {
    
    static func myanmar(_ line : String) -> String {
        var words = [String]()
        
        line.components(separatedBy: " ").forEach { word in
            let outputs  =  RegularExpression.myanmarPattern.stringByReplacingMatches(in: word, withTemplate: "𝕊$1")
            let ouputArray = outputs.components(separatedBy: "𝕊")
            var filtered = [String]()
            
            ouputArray.forEach { char in
                if Syllables.myanamrWords.contains(char) {
                    filtered.append(char)
                }
            }
            words.append(filtered.joined())
        }
//        if (filtered.count > 0) {
//            filtered.remove(at: 0)
//        }
        
        return words.joined(separator: " ")
    }
    
    static func guitar(_ text : String) -> [String] {
        let outputs  =  RegularExpression.chordsRegexForPlainText.stringByReplacingMatches(in: text, withTemplate: "𝕊$1")
        let ouputArray = outputs.components(separatedBy: "𝕊")
        var filtered = [String]()
        
        ouputArray.forEach { word in
            if Syllables.guitarChords.contains(word) {
                filtered.append(word)
            }
        }
        if (filtered.count > 0) {
            filtered.remove(at: 0)
        }
        
        return filtered
    }
}
