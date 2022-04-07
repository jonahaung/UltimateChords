//
//  ImageImporterView.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 7/4/22.
//

import SwiftUI

struct ImageImporterView: View {
    
    @StateObject private var importer: ImageImporter
    @Environment(\.presentationMode) private var presentationMode
    private let completionHandler: (String?) -> Void
    
    init(_ mode: ImageImporter.Mode, completion: @escaping (String?) -> Void) {
        self.completionHandler = completion
        _importer = .init(wrappedValue: .init(mode))
    }

    var body: some View {
        PickerNavigationView {
            GeometryReader { geo in
                VStack {
                    if let image = importer.image {
                        OcrImageView(image: image) { string in
                            completionHandler(string)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
                    .fullScreenCover(item: $importer.mode) { mode in
                        switch mode {
                        case .Camera:
                            CameraView { image in
                                importer.image = image
                            }
                        case .Document_Scanner:
                            DocumentScannerView { images in
                                importer.image = images?.last
                            }.edgesIgnoringSafeArea(.all)
                        case .Photo_Library:
                            CameraView { image in
                                importer.image = image
                            }
                        }
                    }
            }
        }
    }
}
