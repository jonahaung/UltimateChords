//
//  ShapeLayerView.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 12/4/22.
//

import SwiftUI
import AVFoundation
import SwiftyTesseract
import Vision
import Combine
import libtesseract

struct ShapeLayerImageView: UIViewRepresentable {
    
    @EnvironmentObject private var recognizer: TextReconizerImage
    
    func makeUIView(context: Context) -> QuadImageView {
        let view = QuadImageView(image: recognizer.image)
        recognizer.quadImageView = view
        return view
    }
    
    func updateUIView(_ uiView: QuadImageView, context: Context) {
        uiView.setNeedsLayout()
    }
}

class ShaperLayerUIView: UIView {
    override class var layerClass: AnyClass { CAShapeLayer.self }
    var shapeLayer: CAShapeLayer { layer as! CAShapeLayer }
}

class QuadImageView: UIView {
    
    private var originalQuads = [Quadrilateral]()
    
    var imageViewTransform = CGAffineTransform.identity
    private var currentTouchedRect = CGRect.null
    
    
    private let imageView: UIImageView = {
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    private let shapeLayerView: ShaperLayerUIView = {
        $0.shapeLayer.fillColor = UIColor.tintColor.withAlphaComponent(0.3).cgColor
        return $0
    }(ShaperLayerUIView())
    
    private let regionLayer: CAShapeLayer = {
        $0.fillColor = nil
        $0.lineWidth = 1
        $0.strokeColor = UIColor.systemOrange.cgColor
        return $0
    }(CAShapeLayer())
    
    init(image: UIImage) {
        super.init(frame: .zero)
        imageView.image = image
        addSubview(imageView)
        addSubview(shapeLayerView)
        shapeLayerView.shapeLayer.insertSublayer(regionLayer, at: 0)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if originalQuads.isEmpty {
            guard let image = imageView.image else { return }
            
            let imageViewFrame = AVMakeRect(aspectRatio: image.size, insideRect: self.bounds)
            imageView.frame = imageViewFrame
            shapeLayerView.frame = imageViewFrame
            regionLayer.frame = shapeLayerView.bounds
            let scaleT = CGAffineTransform(scaleX: imageViewFrame.width, y: -imageViewFrame.height)
            let translateT = CGAffineTransform(translationX: 0, y: imageViewFrame.height)
            imageViewTransform = scaleT.concatenating(translateT)
        }
    }
}

extension QuadImageView {
    
    func detectTextBoxes() {
        
        guard let buffer = imageView.image?.pixelBuffer() else { return }
        let request = VNRecognizeTextRequest()
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        let handler = VNImageRequestHandler(cvPixelBuffer: buffer, orientation: .up)
        weak var weakSelf = self
        DispatchQueue.global().async {
            guard let strongSelf = weakSelf else { return}
            do {
                try handler.perform([request])
                DispatchQueue.main.async {
                    guard let results = request.results, !results.isEmpty else { return }
                    strongSelf.originalQuads = results.map{ Quadrilateral(rectangleObservation: $0)}
                    strongSelf.displayBoxes()
                }
            } catch {
                print(error)
            }
        }
    }
    
    
    func cropImage() -> UIImage? {
        
        guard let image = imageView.image else { return nil }
        guard let ciImage = CIImage(image: image) else { return nil}
        let viewQuads = originalQuads.filter{ $0.isSelected }.map{ $0.applying(imageViewTransform)}
        
        let boxes = viewQuads.map{$0.regionRect}
        let rect = boxes.reduce(CGRect.null, {$0.union($1)}).surroundingSquare(with: CGSize(width: 10, height: 10))
        
        let quad = Quadrilateral(rect: rect)
        
        let imageViewFrame = imageView.frame
        let imageQuad = quad.scale(imageViewFrame.size, image.size)
        var cartesianScaledQuad = imageQuad.toCartesian(withHeight: image.size.height)
        cartesianScaledQuad.reorganize()
        
        let cgOrientation = CGImagePropertyOrientation(image.imageOrientation)
        let orientedImage = ciImage.oriented(forExifOrientation: Int32(cgOrientation.rawValue))
        
        let filteredImage = orientedImage.applyingFilter("CIPerspectiveCorrection", parameters: [
            "inputTopLeft": CIVector(cgPoint: cartesianScaledQuad.bottomLeft),
            "inputTopRight": CIVector(cgPoint: cartesianScaledQuad.bottomRight),
            "inputBottomLeft": CIVector(cgPoint: cartesianScaledQuad.topLeft),
            "inputBottomRight": CIVector(cgPoint: cartesianScaledQuad.topRight)
        ])
        return filteredImage.uiImage
    }
}
extension QuadImageView {
    
    private func displayBoxes() {
        let viewQuads = originalQuads.filter{ $0.isSelected }.map{ $0.applying(imageViewTransform)}
        
        let boxes = viewQuads.map{$0.regionRect}
        let rect = boxes.reduce(CGRect.null, {$0.union($1)}).surroundingSquare(with: CGSize(width: 10, height: 10))
        
        let quad = Quadrilateral(rect: rect)
        regionLayer.path = quad.path.cgPath
        
        let path = UIBezierPath()
        
        viewQuads.forEach { quad in
            if quad.isSelected {
                path.append(quad.path)
            }
        }
        shapeLayerView.shapeLayer.path = path.cgPath
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        if let last = Array(touches).last {
            let location = last.location(in: shapeLayerView)
            ontouch(with: location, width: 10)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if let last = Array(touches).last {
            let location = last.location(in: shapeLayerView)
            
            currentTouchedRect = .null
            ontouch(with: location, width: 15)
        }
    }
    
    private func ontouch(with location: CGPoint, width: CGFloat) {
        var viewQuads = originalQuads.map{ $0.applying(imageViewTransform)}
        
        let quads = viewQuads.filter{ $0.regionRect.surroundingSquare(with: .init(width: width, height: 10)).contains(location)}
        let rect = quads.map{$0.regionRect}.reduce(CGRect.null, { $0.union($1)})
        
        if quads.isEmpty == false && currentTouchedRect.intersects(rect) == false {
            currentTouchedRect = rect
            for quad in quads {
                if let index = viewQuads.firstIndex(of: quad) {
                    viewQuads[index].toggleSelect()
                    originalQuads[index].toggleSelect()
                }
            }
            displayBoxes()
        }
    }
}
