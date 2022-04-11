//
//  CIImage+Utils.swift
//  WeScan
//
//  Created by Julian Schiavo on 14/11/2018.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import CoreImage
import UIKit

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
