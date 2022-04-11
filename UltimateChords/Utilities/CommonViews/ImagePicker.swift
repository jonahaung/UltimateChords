//
//  ImagePicker.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 11/4/22.
//

import SwiftUI
import UIKit

struct ImagePicker: UIViewControllerRepresentable {
    
    var onPick: (UIImage) -> Void
    
    func makeCoordinator() -> ImagePicker.Coordinator {
        return ImagePicker.Coordinator(parent1: self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: ImagePicker.UIViewControllerType, context: UIViewControllerRepresentableContext<ImagePicker>) {
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var parent: ImagePicker
        
        init(parent1: ImagePicker){
            parent = parent1
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            var image = UIImage()
            if let editedImage = info[.editedImage] as? UIImage {
                image = editedImage
            } else if let originalImage = info[.originalImage] as? UIImage {
                image = originalImage
            }
            
            self.parent.onPick(image)
            picker.dismiss(animated: true)
        }
    }
}

