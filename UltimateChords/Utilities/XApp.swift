//
//  XApp.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 25/3/22.
//

import UIKit

struct XApp {
    struct PDF {
        struct A4 {
            static let size = CGSize(width: 595, height: 842)
            static let margin = UIEdgeInsets(top: 60, left: 30, bottom: 60, right: 30)
            static var availiableWidth: CGFloat { size.width - margin.left - margin.right }
            static var ratio: CGFloat { UIScreen.main.bounds.width / size.width }
        }
    }

    struct TextView {
        static let lineFragmentPadding = CGFloat(8)
    }
    
    struct Image {
        static let resizeWidth:CGFloat = 500
    }
}
