//
//  CGPoint+Utils.swift
//  WeScan
//
//  Created by Boris Emorine on 2/9/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import UIKit

extension CGPoint {
    
    func cartesian(withHeight height: CGFloat) -> CGPoint {
        return CGPoint(x: x, y: height - y)
    }
    func surroundingSquare(withSize size: CGSize) -> CGRect {
        return CGRect(x: x - size.width / 2.0, y: y - size.height / 2.0, width: size.width, height: size.height)
    }
}

extension CGRect {
    
    func surroundingSquare(with s: CGSize) -> CGRect {
        CGRect(x: minX - s.width/2, y: minY - s.height/2, width: width + s.width, height: height + s.height)
    }
}
