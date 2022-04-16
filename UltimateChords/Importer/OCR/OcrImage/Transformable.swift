//
//  Extendable.swift
//  WeScan
//
//  Created by Boris Emorine on 2/15/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import UIKit

/// Objects that conform to the Transformable protocol are capable of being transformed with a `CGAffineTransform`.
protocol Transformable {
    func applying(_ transform: CGAffineTransform) -> Self
}

extension Transformable {

    func applyTransforms(_ transforms: [CGAffineTransform]) -> Self {
        var transformableObject = self
        transforms.forEach { (transform) in
            transformableObject = transformableObject.applying(transform)
        }
        return transformableObject
    }
    
}
