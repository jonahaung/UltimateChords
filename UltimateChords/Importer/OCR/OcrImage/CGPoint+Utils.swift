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
    
}
