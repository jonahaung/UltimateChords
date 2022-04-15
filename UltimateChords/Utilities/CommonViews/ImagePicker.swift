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
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: ImagePicker.UIViewControllerType, context: UIViewControllerRepresentableContext<ImagePicker>) {
    }
    
    func makeCoordinator() -> ImagePicker.Coordinator {
        return ImagePicker.Coordinator(parent1: self)
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
            
            DispatchQueue.main.async {
                self.parent.onPick(image)
                picker.dismiss(animated: true)
            }
        }
    }
}

import PhotosUI
import SwiftUI

public struct ImagePickerMultiple: UIViewControllerRepresentable {
    
    public typealias Completion = (_ selectedImage: [Photo]) -> Void
    
    private var maxLimit: Int
    private var completion: Completion?
    
    public init(maxLimit: Int, completion: Completion?) {
        self.maxLimit = maxLimit
        self.completion = completion
    }
    
    public func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        configuration.filter = .images
        configuration.selectionLimit = maxLimit
        let controller = PHPickerViewController(configuration: configuration)
        controller.delegate = context.coordinator
        return controller
    }
    
    public func updateUIViewController(_: PHPickerViewController, context _: Context) {}
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public class Coordinator: PHPickerViewControllerDelegate {
        
        private let parent: ImagePickerMultiple
        
        init(_ parent: ImagePickerMultiple) {
            self.parent = parent
        }
        
        public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            let group = DispatchGroup()
            var images = [Photo]()
            for result in results {
                group.enter()
                load(result) { image in
                    if let image = image {

                        images.append(image)
                    }
                    group.leave()
                }
            }
            group.notify(queue: .main) { [weak self] in
                guard let self = self else { return }
                self.parent.completion?(images)
            }
        }
        
        private func load(_ image: PHPickerResult, completion: @escaping (Photo?) -> Void ) {
            image.itemProvider.loadDataRepresentation(forTypeIdentifier: UTType.image.identifier) { (data, error) in
                if let error = error {
                    print(error.localizedDescription)
                    completion(nil)
                    return
                }
                
                guard let data = data else {
                    print("unable to unwrap image as UIImage")
                    completion(nil)
                    return
                }
                let photo = Photo(id: image.assetIdentifier ?? UUID().uuidString, originalData: data)
                completion(photo)
            }
        }
    }
}