//
//  ImportableView.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 11/4/22.
//

import SwiftUI

struct LyricImporterView<Content: View>: View {
    
    private let content: () -> Content
    @StateObject private var viewModel = LyricImporterViewModel()
    @EnvironmentObject private var creater: LyricsCreaterViewModel
    @State private var pickedItem = PickedItem.None
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        content()
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: shareButton())
            .fullScreenCover(item: $viewModel.importMode) {
                fullScreenCover(for: $0)
            }
            .fullScreenCover(item: $viewModel.importingImage) {
                OcrImageView(image: $0) { result in
                    DispatchQueue.main.async {
                        viewModel.importingImage = nil
                        DispatchQueue.main.async {
                            switch result {
                            case .OCR(let text):
                                creater.insertText(text)
                            case .Redo:
                                viewModel.redoImportMode()
                            case .Cancel:
                                break
                            }
                        }
                    }
                }
            }
    }
    
    private func fullScreenCover(for mode: LyricImporterViewModel.Mode) -> some View {
        Group {
            switch mode {
            case .Camera:
                CameraView { image in
                    DispatchQueue.main.async {
                        viewModel.importMode = nil
                        DispatchQueue.main.async {
                            viewModel.importingImage = image
                        }
                    }
                }
            case .Document_Scanner:
                DocumentScannerView { images in
                    DispatchQueue.main.async {
                        viewModel.importMode = nil
                        DispatchQueue.main.async {
                            viewModel.importingImage = images?.last
                        }
                    }
                }
                .edgesIgnoringSafeArea(.all)
            case .Photo_Library:
                ImagePickerMultiple(maxLimit: 1) { photos in
                    DispatchQueue.main.async {
                        viewModel.importMode = nil
                        DispatchQueue.main.async {
                            viewModel.importingImage = photos.last?.image
                        }
                    }
                }
                .edgesIgnoringSafeArea(.all)
            case .ChordPro_File:
                DocumentPicker { item in
                    DispatchQueue.main.async {
                        viewModel.importMode = nil
                        DispatchQueue.main.async {
                            switch item {
                            case .Text(let string):
                                creater.insertText(string)
                            case .Image(let uIImage):
                                viewModel.importingImage = uIImage
                            case .None:
                                break
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func shareButton() -> some View {
        Menu {
            ForEach(LyricImporterViewModel.Mode.allCases) { mode in
                Button(mode.description) {
                    DispatchQueue.main.async {
                        viewModel.setImportMode(mode: mode)
                    }
                }
            }
        } label: {
            XIcon(.square_and_arrow_down)
                .padding()
        }
    }
}
