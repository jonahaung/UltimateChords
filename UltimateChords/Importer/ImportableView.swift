//
//  ImportableView.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 11/4/22.
//

import SwiftUI

struct ImportableView<Content: View>: View {
    
    private let content: () -> Content
    private var onDismiss: ((String) -> Void)
    @StateObject private var viewModel = ImportableViewModel()
    
    init(onDismiss: @escaping (String) -> Void, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.onDismiss = onDismiss
    }
    
    var body: some View {
        content()
            .navigationBarItems(leading: shareButton())
            .fullScreenCover(item: $viewModel.importMode) {
                fullScreenCover(for: $0)
            }
            .fullScreenCover(item: $viewModel.importingImage) {
                OcrImageView(image: $0) { text in
                    viewModel.importingImage = nil
                    DispatchQueue.main.async {
                        onDismiss(text)
                    }
                }
            }
    }
    
    private func fullScreenCover(for mode: ImportableViewModel.Mode) -> some View {
        Group {
            switch mode {
            case .Camera:
                CameraView { image in
                    viewModel.importMode = nil
                    viewModel.importingImage = image
                }
            case .Document_Scanner:
                DocumentScannerView { images in
                    viewModel.importMode = nil
                    viewModel.importingImage = images?.last
                }.edgesIgnoringSafeArea(.all)
            case .Photo_Library:
                ImagePickerMultiple(maxLimit: 1) { selectedImage in
                    viewModel.importMode = nil
                    viewModel.importingImage = selectedImage.first?.image
                }
            case .ChordPro_File:
                DocumentPicker { text in
                    viewModel.importMode = nil
                    onDismiss(text)
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
