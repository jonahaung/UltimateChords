//
//  UIImage+Utils.swift
//  WeScan
//
//  Created by Bobo on 5/25/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import UIKit

extension UIImage: Identifiable {}

extension UIImage {
    
    func pixelBuffer() -> CVPixelBuffer? {
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBufferOpt: CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(self.size.width), Int(self.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBufferOpt)
        guard status == kCVReturnSuccess, let pixelBuffer = pixelBufferOpt else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer)
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        guard let context = CGContext(data: pixelData, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue) else {
            return nil
        }
        
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        
        return pixelBuffer
    }
    
    func scaledImage(atPoint point: CGPoint, scaleFactor: CGFloat, targetSize size: CGSize) -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }
        
        let scaledSize = CGSize(width: size.width / scaleFactor, height: size.height / scaleFactor)
        let midX = point.x - scaledSize.width / 2.0
        let midY = point.y - scaledSize.height / 2.0
        let newRect = CGRect(x: midX, y: midY, width: scaledSize.width, height: scaledSize.height)
        
        guard let croppedImage = cgImage.cropping(to: newRect) else {
            return nil
        }
        
        return UIImage(cgImage: croppedImage)
    }
}

