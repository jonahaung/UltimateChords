//
//  ImportableViewModel.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 11/4/22.
//

import Foundation
import UIKit

class ImportableViewModel: ObservableObject {
    @Published var importMode: Mode?
    @Published var importingImage: UIImage?
}

extension ImportableViewModel {
    enum Mode: String, CustomStringConvertible, CaseIterable, Identifiable {
        case Document_Scanner, Camera, Photo_Library, ChordPro_File
        var id: String { rawValue }
        var description: String {
            rawValue.replacingOccurrences(of: "_", with: " ")
        }
    }
}
