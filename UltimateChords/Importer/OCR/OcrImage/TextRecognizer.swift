//
//  TextRecognizing.swift
//  MyanmarLens2
//
//  Created by Aung Ko Min on 19/5/21.
//

import UIKit
import SwiftyTesseract

final class TextRecognizer {

    private let tesseract: Tesseract
    private let queue = DispatchQueue(label: "com.jonahaung.TextRecognizer", qos: .userInteractive)
    private var onGetText: ((String?) -> Void)?
    
    init() {
        tesseract = .init(languages: [.burmese, .english])
        tesseract.configure {
            set(.preserveInterwordSpaces, value: .true)
        }
    }
    
    deinit {
        print("Deinit: TextRecognizer")
    }
    
    func detectTexts(from image: UIImage,  _ completion: @escaping (String?) -> Void) {
        self.onGetText = completion
        queue.async { [weak self] in
            guard let self = self else { return }
            do {
                let string = try self.tesseract.performOCR(on: image).get()
                self.onGetText?(string)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
