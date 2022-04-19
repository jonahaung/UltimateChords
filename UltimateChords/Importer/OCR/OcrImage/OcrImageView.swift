//
//  ImageViewer.swift
//  SwiftUICamera
//
//  Created by Aung Ko Min on 5/4/22.
//

import SwiftUI

struct OcrImageView: View {
    
    @StateObject private var viewModel: OCRImageViewModel
    
    private var onDismiss: ((ResultType) -> Void)
    
    init(image: UIImage, onDismiss: @escaping (ResultType) -> Void) {
        _viewModel = .init(wrappedValue: .init(image: image))
        self.onDismiss = onDismiss
    }
    
    var body: some View {
        PickerNavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                VStack(spacing: 0) {
                    Spacer()
                    QuadrilateralImageView(viewModel: viewModel)
                        .overlay(loadingView())
                    Spacer()
                    bottomBar()
                }
            }
            .navigationBarItems(trailing: retakeButton())
            .task {
                viewModel.task()
            }
            .onChange(of: viewModel.text) { newValue in
                DispatchQueue.main.async {
                    if let text = newValue {
                        onDismiss(.Success(text: text))
                    } else {
                        onDismiss(.Cancel)
                    }
                }
            }
        }
        .accentColor(.white)
    }
    
    private func retakeButton() -> some View {
        Button("Retake") {
            onDismiss(.Redo)
        }
    }
    private func bottomBar() -> some View {
        HStack {
            Button("Reset", role: .cancel) {
                viewModel.reset()
            }
            .disabled(!viewModel.hasChanges)
            Spacer()
            Menu {
                ForEach(ImageFilterMode.allCases) { mode in
                    Button(mode.description) {
                        viewModel.filter(mode)
                    }
                }
            } label: {
                XIcon(.camera_filters)
            }
            Spacer()
            Button("DETECT") {
                viewModel.detextTexts()
            }
            .buttonStyle(.bordered)
            .disabled(viewModel.recognizingText)
        }
        .padding(.horizontal)
        
    }
    private func loadingView() -> some View {
        Group {
            if viewModel.recognizingText {
                ProgressView()
            }
        }
    }
}

extension OcrImageView {
    
    enum ResultType {
        case Success(text: String)
        case Redo
        case Cancel
    }
}
