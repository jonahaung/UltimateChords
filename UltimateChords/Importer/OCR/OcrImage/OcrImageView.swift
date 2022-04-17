//
//  ImageViewer.swift
//  SwiftUICamera
//
//  Created by Aung Ko Min on 5/4/22.
//

import SwiftUI

struct OcrImageView: View {
    
    @StateObject private var recognizer: OCRImageViewModel
    
    private var onDismiss: ((ResultType) -> Void)
    
    init(image: UIImage, onDismiss: @escaping (ResultType) -> Void) {
        _recognizer = .init(wrappedValue: .init(image: image))
        self.onDismiss = onDismiss
    }
    
    var body: some View {
        PickerNavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                QuadrilateralImageView(recognizer: recognizer)
                    .overlay(loadingView())
            }
            .overlay(bottomBar(), alignment: .bottom)
            .task {
                recognizer.task()
            }
            .onChange(of: recognizer.text) { newValue in
                DispatchQueue.main.async {
                    if let text = newValue {
                        onDismiss(.Success(text: text))
                    }
                }
            }
        }
    }
    
    private func bottomBar() -> some View {
        HStack {
            Button("Retake") {
                onDismiss(.Redo)
            }
            Spacer()
            Button("DETECT") {
                recognizer.detextTexts()
            }
            .buttonStyle(.borderedProminent)
            .disabled(recognizer.recognizingText)
        }.padding()
    }
    private func loadingView() -> some View {
        Group {
            if recognizer.recognizingText {
                ProgressView().padding().background(Color(uiColor: .secondarySystemGroupedBackground).clipShape(Circle()))
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
