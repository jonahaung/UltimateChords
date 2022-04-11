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
        GeometryReader { geo in
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                Image(uiImage: recognizer.image)
                    .resizable()
                    .scaledToFit()
                    .overlay(croppedImage(width: geo.size.width/3), alignment: .bottomTrailing)
                    .task {
                        recognizer.task()
                    }
                    .onChange(of: recognizer.text) { newValue in
                        self.completionHandler(newValue)
                        presentationMode.wrappedValue.dismiss()
                    }
                
                
            }
        }
    }
    private func croppedImage(width: CGFloat) -> some View {
        Group {
            if let image = recognizer.croppedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: width)
                    .transition(.move(edge: .trailing))
                    .overlay(ProgressView())
                    .shadow(radius: 2)
            }
        }
    }
}
