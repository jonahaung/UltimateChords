//
//  ImageViewer.swift
//  SwiftUICamera
//
//  Created by Aung Ko Min on 5/4/22.
//

import SwiftUI

struct OcrImageView: View {
    
    @StateObject private var recognizer: TextReconizerImage
    
    @Environment(\.presentationMode) private var presentationMode
    private let completionHandler: (String?) -> Void
    
    init(image: UIImage, completion: @escaping (String?) -> Void) {
        self.completionHandler = completion
        _recognizer = .init(wrappedValue: .init(image: image))
    }
    
    var body: some View {
        Image(uiImage: recognizer.image)
            .resizable()
            .scaledToFit()
            .overlay(loadingView)
            .task {
                recognizer.task()
            }
            .onChange(of: recognizer.text) { newValue in
                self.completionHandler(newValue)
                presentationMode.wrappedValue.dismiss()
            }
    }
    
    private var loadingView: some View {
        Group {
            if recognizer.showLoading {
                ProgressView()
            }
        }
    }
}
