//
//  ImageViewer.swift
//  SwiftUICamera
//
//  Created by Aung Ko Min on 5/4/22.
//

import SwiftUI

struct OcrImageView: View {
    
    @StateObject var viewModel: OCRImageViewModel
    @Binding var result: ResultType?
    @Environment(\.dismiss) private var dismiss
    
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
                        result = .OCR(text: SongParser.format(text))
                    } else {
                        result = .Cancel
                    }
                    dismiss()
                }
            }
        }
        .accentColor(.white)
    }
    
    private func retakeButton() -> some View {
        Button("Retake") {
            result = .Redo
            dismiss()
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
            .disabled(viewModel.isRecognizingText)
        }
        .padding(.horizontal)
    }
    
    private func loadingView() -> some View {
        Group {
            if viewModel.isRecognizingText {
                ProgressView()
                    .padding()
                    .background(Color(uiColor: .systemBackground))
                    .clipShape(Circle())
            }
        }
    }
}

extension OcrImageView {
    
    enum ResultType {
        case OCR(text: String)
        case Redo
        case Cancel
    }
}
