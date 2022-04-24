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
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        content()
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: shareButton())
            .fullScreenCover(item: $viewModel.importMode, onDismiss: {
                DispatchQueue.main.async {
                    if let item = viewModel.pickedItem {
                        switch item {
                        case .Text(let string):
                            creater.insertText(string)
                        case .Image(let uIImage):
                            viewModel.pickedImage = uIImage
                        case .None:
                            break
                        }
                    }
                }
            }, content: { mode in
                switch mode {
                case .Camera:
                    CameraView(item: $viewModel.pickedItem)
                case .Document_Scanner:
                    DocumentScannerView(item: $viewModel.pickedItem)
                        .edgesIgnoringSafeArea(.all)
                case .Photo_Library:
                    SystemImagePicker(item: $viewModel.pickedItem)
                        .edgesIgnoringSafeArea(.all)
                case .ChordPro_File:
                    DocumentPicker(item: $viewModel.pickedItem)
                        .edgesIgnoringSafeArea(.all)
                }
            })
            .fullScreenCover(item: $viewModel.pickedImage, onDismiss: {
                DispatchQueue.main.async {
                    if let result = viewModel.ocrResult {
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
            }, content: {
                OcrImageView(viewModel: .init(image: $0), result: $viewModel.ocrResult)
            })
            
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
