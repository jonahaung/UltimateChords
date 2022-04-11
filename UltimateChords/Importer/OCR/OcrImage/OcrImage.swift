//
//  TextReconizerImage.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 7/4/22.
//

import Foundation
import UIKit
import Vision
import SwiftyTesseract
import AVFoundation
import SwiftUI
import Combine

class TextReconizerImage: ObservableObject {
    
    @Published var image: UIImage
    @Published var croppedImage: UIImage?
    var text: String?
    
    private let ocrQueue = DispatchQueue(label: "OCR")
    private var subscription: Set<AnyCancellable> = []
    
    init(image: UIImage) {
        self.image = image
        
    }
    
    deinit {
        print("Deinit: TextRecognizerImage")
    }
}

extension TextReconizerImage {
    func task() {
        ocrQueue.async { [weak self] in
            guard let self = self else { return }
            self.cropToTextBoxes(image: self.image)
        }
    }
    
    private func cropToTextBoxes(image: UIImage) {
        guard let buffer = image.pixelBuffer() else { return }
        let request = VNRecognizeTextRequest(completionHandler: textRecognitionHandler)
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        let handler = VNImageRequestHandler(cvPixelBuffer: buffer, orientation: .up)
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
    }
    private func textRecognitionHandler(request: VNRequest, error: Error?) {
        guard let results = request.results as? [VNRecognizedTextObservation], !results.isEmpty else { return }
       
        guard let ciImage = CIImage(image: image) else { return }
        
        let boxes = results.map{$0.boundingBox}
        let rect = boxes.reduce(CGRect.null, {$0.union($1)})
        let quad = Quadrilateral(rect: rect)
        
        let imageViewFrame = AVMakeRect(aspectRatio: image.size, insideRect: UIScreen.main.bounds)
        let imageSize = image.size
        
        let scaleT = CGAffineTransform(scaleX: imageViewFrame.width, y: -imageViewFrame.height)
        let translateT = CGAffineTransform(translationX: 0, y: imageViewFrame.height)
        let cameraTansform = scaleT.concatenating(translateT)
        
        let scaledQuad = quad.applying(cameraTansform).scale(imageViewFrame.size, imageSize)
        var cartesianScaledQuad = scaledQuad.toCartesian(withHeight: imageSize.height)
        cartesianScaledQuad.reorganize()
        
        let cgOrientation = CGImagePropertyOrientation(image.imageOrientation)
        let orientedImage = ciImage.oriented(forExifOrientation: Int32(cgOrientation.rawValue))
        
        let filteredImage = orientedImage.applyingFilter("CIPerspectiveCorrection", parameters: [
            "inputTopLeft": CIVector(cgPoint: cartesianScaledQuad.bottomLeft),
            "inputTopRight": CIVector(cgPoint: cartesianScaledQuad.bottomRight),
            "inputBottomLeft": CIVector(cgPoint: cartesianScaledQuad.topLeft),
            "inputBottomRight": CIVector(cgPoint: cartesianScaledQuad.topRight)
        ])
        
        if let uiImage = filteredImage.uiImage {
            ocrQueue.async {
                DispatchQueue.main.async {
                    withAnimation(.interactiveSpring()) {
                        self.croppedImage = uiImage
                    }
                }
            }
            self.detectTexts(forImage: uiImage)
        }
    }
    
    
    
    
    
    private func detectTexts(forImage image: UIImage) {
       
        let tesseract: Tesseract = Tesseract(languages: [RecognitionLanguage.burmese, RecognitionLanguage.english])
        tesseract.configure {
            set(.preserveInterwordSpaces, value: .true)
        }
        
        tesseract.performOCRPublisher(on: image)
            .subscribe(on: ocrQueue)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { comp in
                self.objectWillChange.send()
            }, receiveValue: { text in
                self.text = text
            })
            .store(in: &subscription)
    }
}

