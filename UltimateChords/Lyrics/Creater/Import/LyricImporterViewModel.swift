//
//  ImportableViewModel.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 11/4/22.
//

import UIKit

class LyricImporterViewModel: ObservableObject {
    
    @Published var importMode: Mode?
    private var previousImportMode: Mode?
    @Published var importingImage: UIImage?
    
    deinit {
        print("DEINIT: ImportableViewModel")
    }
    
    func setImportMode(mode: Mode?) {
        importMode = mode
        previousImportMode = mode
    }
    func redoImportMode() {
        setImportMode(mode: previousImportMode)
    }
}

extension LyricImporterViewModel {
    enum Mode: String, CustomStringConvertible, CaseIterable, Identifiable {
        case Document_Scanner, Camera, Photo_Library, ChordPro_File
        var id: String { rawValue }
        var description: String {
            rawValue.replacingOccurrences(of: "_", with: " ")
        }
    }
}
