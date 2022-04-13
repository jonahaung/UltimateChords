//
//  ImageViewer.swift
//  SwiftUICamera
//
//  Created by Aung Ko Min on 5/4/22.
//

import SwiftUI

struct OcrImageView: View {
    
    @StateObject private var recognizer: TextReconizerImage
    
    private var onDismiss: ((String) -> Void)
    
    init(image: UIImage, onDismiss: @escaping (String) -> Void) {
        _recognizer = .init(wrappedValue: .init(image: image))
        self.onDismiss = onDismiss
    }
    
    var body: some View {
        PickerNavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                ShapeLayerImageView()
                    .environmentObject(recognizer)
                    .overlay(loadingView())
            }
            .overlay(bottomBar(), alignment: .bottom)
            .task {
                recognizer.task()
            }
            .onChange(of: recognizer.text) { newValue in
                if let text = newValue {
                    onDismiss(text)
                }
            }
        }
    }
    
    private func bottomBar() -> some View {
        HStack {
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
