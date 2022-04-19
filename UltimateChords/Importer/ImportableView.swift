//
//  ImportableView.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 11/4/22.
//

import SwiftUI

struct ImportableView<Content: View>: View {
    
    private let content: () -> Content
    @StateObject private var viewModel = ImportableViewModel()
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
                            case .Success(let text):
                                print(text)
                                creater.insertText(SongParser.convert(text))
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
    
    private func fullScreenCover(for mode: ImportableViewModel.Mode) -> some View {
        Group {
            switch mode {
            case .Camera:
                CameraView { image in
                    DispatchQueue.main.async {
                        viewModel.importMode = nil
                        viewModel.importingImage = image
                    }
                }
            case .Document_Scanner:
                DocumentScannerView { images in
                    DispatchQueue.main.async {
                        viewModel.importMode = nil
                        viewModel.importingImage = images?.last
                    }
                }.edgesIgnoringSafeArea(.all)
            case .Photo_Library:
                ImagePicker { selectedImage in
                    viewModel.importMode = nil
                    viewModel.importingImage = selectedImage
                }
            case .ChordPro_File:
                DocumentPicker { item in
                    viewModel.importMode = nil
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
    
    private func shareButton() -> some View {
        Menu {
            ForEach(ImportableViewModel.Mode.allCases) { mode in
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
