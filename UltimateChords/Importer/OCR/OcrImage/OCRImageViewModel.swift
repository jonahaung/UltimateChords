//
//  TextReconizerImage.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 7/4/22.
//

import Foundation
import UIKit
import SwiftyTesseract
import SwiftUI

class OCRImageViewModel: ObservableObject {
    
    weak var quadImageView: QuadImageView?
    let image: UIImage
    @Published var recognizingText = false
    @Published var text: String?
    
    private let ocrQueue = DispatchQueue(label: "OCR")
    init(image: UIImage) {
        self.image = image
    }
    
    deinit {
        print("Deinit: TextRecognizerImage")
    }
}

extension OCRImageViewModel {
    
    func task() {
        self.quadImageView?.detectTextBoxes()
    }
    
    func detextTexts() {
        if let uiImage = quadImageView?.cropImage() {
            self.recognizingText = true
            self.detectTexts(forImage: uiImage)
        }
    }
    
    private func detectTexts(forImage image: UIImage) {
        weak var weakSelf = self
        let tesseract: Tesseract = {
            $0.configure {
                set(.preserveInterwordSpaces, value: .true)
            }
            return $0
        }(Tesseract(languages: [RecognitionLanguage.burmese, RecognitionLanguage.english]))
        
        ocrQueue.async {
            guard let self = weakSelf else { return }
            do {
                let string = try tesseract.performOCR(on: image).get()
                DispatchQueue.main.async {
                    self.text = string
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

