//
//  ImportableView.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 11/4/22.
//

import SwiftUI

struct ImportableView<Content: View>: View {
    
    private let content: () -> Content
    private let onReceiveText: (String) -> Void
    
    init(@ViewBuilder content: @escaping () -> Content, onReceiveText: @escaping (String) -> Void) {
        self.content = content
        self.onReceiveText = onReceiveText
    }
    
    @StateObject private var viewModel = ImportableViewModel()
    
    var body: some View {
        content()
            .navigationBarItems(leading: shareButton())
            .fullScreenCover(item: $viewModel.importMode) {
                fullScreenCover(for: $0)
            }
            .fullScreenCover(item: $viewModel.importingImage) { image in
                OcrImageView(image: image) { string in
                    if let string = string {
                        self.onReceiveText(string)
                    }
                }
            }
    }
    
    private func fullScreenCover(for mode: ImportableViewModel.Mode) -> some View {
        Group {
            switch mode {
            case .Camera:
                CameraView { image in
                    viewModel.importingImage = image
                }
            case .Document_Scanner:
                DocumentScannerView { images in
                    viewModel.importingImage = images?.last
                }.edgesIgnoringSafeArea(.all)
            case .Photo_Library:
                ImagePicker { image in
                    print(image)
                    viewModel.importingImage = image
                }
            case .ChordPro_File:
                DocumentPicker {
                    onReceiveText($0)
                }
            }
        }
    }
    
    private func shareButton() -> some View {
        Menu {
            ForEach(ImportableViewModel.Mode.allCases) { mode in
                Button(mode.description) {
                    viewModel.importMode = mode
                }
            }
        } label: {
            XIcon(.square_and_arrow_up)
                .padding()
        }
    }
}
