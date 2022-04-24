//
//  TextReconizerImage.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 7/4/22.
//


import SwiftUI

class OCRImageViewModel: ObservableObject {
    
    @Published var hasChanges = false
    @Published var isRecognizingText = false
    @Published var text: String?

    private lazy var textRecognizer = TextRecognizer()
    let image: UIImage
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
        quadImageView?.detectTextBoxes()
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
            self.isRecognizingText = true
            DispatchQueue.global().async { [weak self] in
                guard let self = self else { return }
                self.textRecognizer.detectTexts(from: ImageResizer(targetWidth: 200).resize(image: uiImage)) { [weak self] string in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        self.text = string.str
                    }
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
