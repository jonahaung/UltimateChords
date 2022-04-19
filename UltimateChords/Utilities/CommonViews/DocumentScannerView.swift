//
//  DocumentScannerView.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 7/4/22.
//

import UIKit
import SwiftUI
import VisionKit
import Vision

struct DocumentScannerView: UIViewControllerRepresentable {
    private let completionHandler: ([UIImage]?) -> Void
     
    init(completion: @escaping ([UIImage]?) -> Void) {
        self.completionHandler = completion
    }
     
    typealias UIViewControllerType = VNDocumentCameraViewController
     
    func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentScannerView>) -> VNDocumentCameraViewController {
        let viewController = VNDocumentCameraViewController()
        viewController.delegate = context.coordinator
        return viewController
    }
     
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: UIViewControllerRepresentableContext<DocumentScannerView>) {}
     
    func makeCoordinator() -> Coordinator {
        return Coordinator(completion: completionHandler)
    }
     
    final class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        
        private let completionHandler: ([UIImage]?) -> Void
         
        init(completion: @escaping ([UIImage]?) -> Void) {
            self.completionHandler = completion
        }
         
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            DispatchQueue.main.async {
                print("Document camera view controller did finish with ", scan)
                let images = (0..<scan.pageCount).compactMap({ scan.imageOfPage(at: $0) })
                self.completionHandler(images)
            }
        }
         
        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            controller.dismiss(animated: true)
            completionHandler(nil)
        }
         
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            print("Document camera view controller did finish with error ", error)
            controller.dismiss(animated: true)
            completionHandler(nil)
        }
    }
}

