//
//  ShapeLayerView.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 12/4/22.
//

import SwiftUI
import AVFoundation
import Vision

struct QuadrilateralImageView: UIViewRepresentable {
    
    let viewModel: OCRImageViewModel
    
    func makeUIView(context: Context) -> QuadImageView {
        let view = QuadImageView()
        viewModel.quadImageView = view
        return view
    }
    
    func updateUIView(_ uiView: QuadImageView, context: Context) {
        
    }
}


class QuadImageView: UIView {
    
    private var originalQuads = [Quadrilateral]()
    private var chords = [Chord]()
    
    var imageViewTransform = CGAffineTransform.identity
    private var currentTouchedRect = CGRect.null
    
    
    let imageView: UIImageView = {
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    let quadView: QuadrilateralView = {
        return $0
    }(QuadrilateralView())
    
    private var previousPanPosition: CGPoint?
    private var closestCorner: CornerPosition?
    
    init() {
        super.init(frame: .zero)
        addSubview(imageView)
        addSubview(quadView)
        let panGesture = UILongPressGestureRecognizer(target: self, action: #selector(handle(gesture:)))
        panGesture.minimumPressDuration = 0.0
        self.addGestureRecognizer(panGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func calculateTransform() {
        guard let image = imageView.image else { return }
        
        let imageViewFrame = AVMakeRect(aspectRatio: image.size, insideRect: self.bounds)
        imageView.frame = imageViewFrame
        quadView.frame = imageViewFrame
        let scaleT = CGAffineTransform(scaleX: imageViewFrame.width, y: -imageViewFrame.height)
        let translateT = CGAffineTransform(translationX: 0, y: imageViewFrame.height)
        imageViewTransform = scaleT.concatenating(translateT)
    }
    
    func updateImage(_ image: UIImage) {
        self.imageView.image = image
        detectTextBoxes()
    }
}

extension QuadImageView {
    private func detectTextBoxes() {
        calculateTransform()
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
                    var chords = [Chord]()
                    results.filter{ $0.confidence > 0.4}.forEach { observation in
                        if let top = observation.topCandidates(1).first {
                            let string = top.string
                            if let chord = Chord.chord(for: string) {
                                if chords.contains(chord) == false {
                                    chords.append(chord)
                                }
                            }
                        }
                    }
                    strongSelf.chords = chords
                }
            } catch {
                print(error)
            }
        }
    }
    func getChords() -> [Chord] {
        self.chords
    }
    private func displayBoxes() {
        let viewQuads = originalQuads.map{ $0.applying(imageViewTransform)}
        
        let boxes = viewQuads.map{$0.regionRect}
        let rect = boxes.reduce(CGRect.null, {$0.union($1)})
        
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
        case .changed:
            
            let position = gesture.location(in: quadView)
            
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
        default:
            break
        }
    }
}
