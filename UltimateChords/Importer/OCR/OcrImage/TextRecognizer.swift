//
//  TextRecognizing.swift
//  MyanmarLens2
//
//  Created by Aung Ko Min on 19/5/21.
//

import UIKit
import SwiftyTesseract

final class TextRecognizer {

    private let tesseract = SwiftyTesseract(languages: [.burmese, .english], dataSource: Bundle.main, engineMode: .lstmOnly)

    
    init() {
        tesseract.preserveInterwordSpaces = true
    }
    deinit {
        print("Deinit: TextRecognizer")
    }
    
    func detectTexts(from image: UIImage,  _ completion: @escaping (String?) -> Void) {
        tesseract.performOCR(on: image, completionHandler: completion)
    }
}
