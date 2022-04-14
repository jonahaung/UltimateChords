//
//  ImageFiltering.swift
//  MyanmarLens2
//
//  Created by Aung Ko Min on 19/5/21.
//

import UIKit

protocol ImageFiltering {
    
    func imageFiltering_applyNoirFilter(image: UIImage) -> UIImage?
    func imageFiltering_applyBlackAndWhiteFilter(image: UIImage) -> UIImage?
    func imageFiltering_cropImageToSelectedArea(image: UIImage, quad: Quadrilateral, canvasSize: CGSize) -> UIImage?
}


extension ImageFiltering {
    
    func imageFiltering_applyNoirFilter(image: UIImage) -> UIImage? {
        guard let openGLContext = EAGLContext(api: .openGLES2), let currentFilter = CIFilter(name: "CIPhotoEffectNoir") else { return nil }
        
        let ciContext = CIContext(eaglContext: openGLContext)
        currentFilter.setValue(CIImage(image: image), forKey: kCIInputImageKey)
        if let output = currentFilter.outputImage,
           let cgImage = ciContext.createCGImage(output, from: output.extent) {
            return UIImage(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation)
        }
        return nil
    }
    
    func imageFiltering_applyBlackAndWhiteFilter(image: UIImage) -> UIImage? {
        let ciImage = CIImage(image: image)
        let cgOrientation = CGImagePropertyOrientation(image.imageOrientation)
        let orientedImage = ciImage?.oriented(forExifOrientation: Int32(cgOrientation.rawValue))
        return orientedImage?.applyingAdaptiveThreshold()?.uiImage ?? image
    }
    
    func imageFiltering_applyNoiceReduce(image: UIImage) -> UIImage? {
        let ciImage = CIImage(image: image)
        let cgOrientation = CGImagePropertyOrientation(image.imageOrientation)
        let orientedImage = ciImage?.oriented(forExifOrientation: Int32(cgOrientation.rawValue))
        return orientedImage?.appalyingNoiseReduce()?.uiImage ?? image
    }
    
    func imageFiltering_cropImageToSelectedArea(image: UIImage, quad: Quadrilateral, canvasSize: CGSize) -> UIImage? {
        let imageSize = image.size
        
        let scaleT = CGAffineTransform.scaleTransform(forSize: canvasSize, aspectFillInSize: imageSize)
        
        var newQuad = quad.applying(scaleT).toCartesian(withHeight: imageSize.height)
        newQuad.reorganize()
        
        guard let ciImage = CIImage(image: image) else { return nil }
        let cgOrientation = CGImagePropertyOrientation(image.imageOrientation)
        let orientedImage = ciImage.oriented(forExifOrientation: Int32(cgOrientation.rawValue))
        
        let filteredImage = orientedImage.applyingFilter("CIPerspectiveCorrection", parameters: [
            "inputTopLeft": CIVector(cgPoint: newQuad.bottomLeft),
            "inputTopRight": CIVector(cgPoint: newQuad.bottomRight),
            "inputBottomLeft": CIVector(cgPoint: newQuad.topLeft),
            "inputBottomRight": CIVector(cgPoint: newQuad.topRight)
        ])
        return filteredImage.uiImage
    }
}
extension CIImage {
    /// Applies an AdaptiveThresholding filter to the image, which enhances the image and makes it completely gray scale
    func applyingAdaptiveThreshold() -> CIImage? {
        guard let colorKernel = CIColorKernel(source:
                                                """
            kernel vec4 color(__sample pixel, float inputEdgeO, float inputEdge1)
            {
                float luma = dot(pixel.rgb, vec3(0.2126, 0.7152, 0.0722));
                float threshold = smoothstep(inputEdgeO, inputEdge1, luma);
                return vec4(threshold, threshold, threshold, 1.0);
            }
            """
        ) else { return nil }
        
        let firstInputEdge = 0.1
        let secondInputEdge = 0.4
        
        let arguments: [Any] = [self, firstInputEdge, secondInputEdge]
        
        return colorKernel.apply(extent: self.extent, arguments: arguments)
        
    }
    
    func adjustColors() -> CIImage? {
        let filter = CIFilter(name: "CIColorControls",
                              parameters: [kCIInputImageKey: self,
                                      kCIInputSaturationKey: 0,
                                        kCIInputContrastKey: 1.45])
        return filter?.outputImage
    }
}

extension CGImage {
    
    func grayscaled() -> CGImage? {
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)
        let cgContext = CGContext(data: nil,
                                  width: self.width,
                                  height: self.height,
                                  bitsPerComponent: 8,
                                  bytesPerRow: 0,
                                  space: colorSpace,
                                  bitmapInfo: bitmapInfo.rawValue)
        cgContext?.draw(self,
                        in: CGRect(x: 0, y: 0, width: self.width, height: self.height))
        
        return cgContext?.makeImage()
    }
    
    var uiImage: UIImage { return UIImage(cgImage: self)}
}

extension CIImage {
    
    func appalyingNoiseReduce() -> CIImage? {
        guard let noiseReduction = CIFilter(name: "CINoiseReduction") else { return nil}
        noiseReduction.setValue(self, forKey: kCIInputImageKey)
        noiseReduction.setValue(0.02, forKey: "inputNoiseLevel")
        noiseReduction.setValue(0.40, forKey: "inputSharpness")
        
        return noiseReduction.outputImage
    }
    
    var cgImage: CGImage? { return CIContext().createCGImage(self, from: self.extent)}
    
    var uiImage: UIImage? {
        if let cgImage = cgImage {
            return UIImage(cgImage: cgImage)
        }
        return nil
    }
}
