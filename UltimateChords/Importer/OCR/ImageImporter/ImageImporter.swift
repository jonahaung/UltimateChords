//
//  ImageImporter.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 7/4/22.
//

import Foundation
import UIKit

class ImageImporter: ObservableObject {
    
    @Published var mode: Mode?
    @Published var image: UIImage?
    
    init(_ mode: Mode) {
        self.mode = mode
    }
}

extension ImageImporter {
    
    enum Mode: String, CustomStringConvertible, CaseIterable, Identifiable {
        case Document_Scanner, Camera, Photo_Library
        var id: String { rawValue }
        var description: String {
            rawValue.replacingOccurrences(of: "_", with: " ")
        }
    }
}
