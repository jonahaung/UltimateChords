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

struct QuadrilateralImageView: UIViewRepresentable {
    
    @EnvironmentObject private var recognizer: OCRImageViewModel
    
    func makeUIView(context: Context) -> QuadImageView {
        let view = QuadImageView(image: recognizer.image)
        recognizer.quadImageView = view
        return view
    }
    
    func updateUIView(_ uiView: QuadImageView, context: Context) {
//        uiView.setNeedsLayout()
    }
}


class QuadImageView: UIView, ImageFiltering {
    
    private var originalQuads = [Quadrilateral]()
    
    var imageViewTransform = CGAffineTransform.identity
    private var currentTouchedRect = CGRect.null
    
    
    private let imageView: UIImageView = {
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    private let quadView: QuadrilateralView = {
        return $0
    }(QuadrilateralView())
    
    private var previousPanPosition: CGPoint?
    private var closestCorner: CornerPosition?

    init(image: UIImage) {
        super.init(frame: .zero)
        imageView.image = image
        addSubview(imageView)
        addSubview(quadView)
        let panGesture = UILongPressGestureRecognizer(target: self, action: #selector(handle(gesture:)))
        panGesture.minimumPressDuration = 0.0
        quadView.addGestureRecognizer(panGesture)
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
            quadView.frame = imageViewFrame
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
        guard let quad = quadView.viewQuad else { return nil }
        
        let imageViewFrame = imageView.frame
        let imageSize = image.size
        
        let imageQuad = quad.scale(imageViewFrame.size, imageSize)
        var cartesianScaledQuad = imageQuad.toCartesian(withHeight: imageSize.height)
        cartesianScaledQuad.reorganize()
        
        let cgOrientation = CGImagePropertyOrientation(image.imageOrientation)
        let orientedImage = ciImage.oriented(forExifOrientation: Int32(cgOrientation.rawValue))
        
        let filteredImage = orientedImage.applyingFilter("CIPerspectiveCorrection", parameters: [
            "inputTopLeft": CIVector(cgPoint: cartesianScaledQuad.bottomLeft),
            "inputTopRight": CIVector(cgPoint: cartesianScaledQuad.bottomRight),
            "inputBottomLeft": CIVector(cgPoint: cartesianScaledQuad.topLeft),
            "inputBottomRight": CIVector(cgPoint: cartesianScaledQuad.topRight)
        ])
        if let image = filteredImage.cgImage?.uiImage {
            return ImageResizer(targetWidth: imageViewFrame.width).resize(image: image)
        }
        return nil
    }
}
extension QuadImageView {
    
    private func displayBoxes() {
        let viewQuads = originalQuads.filter{ $0.isSelected }.map{ $0.applying(imageViewTransform)}
        
        let boxes = viewQuads.map{$0.regionRect}
        let rect = boxes.reduce(CGRect.null, {$0.union($1)}).surroundingSquare(with: CGSize(width: 10, height: 10))
        
        let quad = Quadrilateral(rect: rect)
        quadView.drawQuadrilateral(quad: quad)
        
        let path = UIBezierPath()
        
        viewQuads.forEach { quad in
            if quad.isSelected {
                path.append(quad.path)
            }
        }
        quadView.quadLayer.path = path.cgPath
    }
}

// Gesture

extension QuadImageView {
    
    @objc private func handle(gesture: UIGestureRecognizer) {
        
        guard
            let drawnQuad = quadView.viewQuad,
            let image = imageView.image
        else {
            return
        }
        
        switch gesture.state {
        case .began:
            break
//            delegate?.quadImageUIViewDelegate(self, gestureDidStart: true)
        case .changed:
            
            let position = gesture.location(in: quadView)
            
//            let isTouchingInside = quadView.quadLineLayer.path?.boundingBoxOfPath.contains(position) == true
//
//            guard isTouchingInside else {
//                return
//            }
            let previousPanPosition = self.previousPanPosition ?? position
            let closestCorner = self.closestCorner ?? position.closestCornerFrom(quad: drawnQuad)
            
            let offset = CGAffineTransform(translationX: position.x - previousPanPosition.x, y: position.y - previousPanPosition.y)
            let cornerView = quadView.cornerViewForCornerPosition(position: closestCorner)
            let draggedCornerViewCenter = cornerView.center.applying(offset)
            
            quadView.moveCorner(cornerView: cornerView, atPoint: draggedCornerViewCenter)
            
            self.previousPanPosition = position
            self.closestCorner = closestCorner
            
            let scale = image.size.width / quadView.bounds.size.width
            let scaledDraggedCornerViewCenter = CGPoint(x: draggedCornerViewCenter.x * scale, y: draggedCornerViewCenter.y * scale)
            guard let zoomedImage = image.scaledImage(atPoint: scaledDraggedCornerViewCenter, scaleFactor: 5, targetSize: quadView.bounds.size) else {
                return
            }
            quadView.highlightCornerAtPosition(position: closestCorner, with: zoomedImage)
        case .ended:
            previousPanPosition = nil
            closestCorner = nil
            quadView.resetHighlightedCornerViews()
//            delegate?.quadImageUIViewDelegate(self, quadDidUpdate: drawnQuad)
//            delegate?.quadImageUIViewDelegate(self, gestureDidStart: false)
        default:
            break
        }
    }
}
