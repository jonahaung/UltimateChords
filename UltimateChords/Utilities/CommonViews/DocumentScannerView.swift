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
    
    @Environment(\.dismiss) private var dismiss
    @Binding var item: PickedItem?
     
    typealias UIViewControllerType = VNDocumentCameraViewController
     
    func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentScannerView>) -> VNDocumentCameraViewController {
        let viewController = VNDocumentCameraViewController()
        viewController.delegate = context.coordinator
        return viewController
    }
     
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: UIViewControllerRepresentableContext<DocumentScannerView>) {}
     
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
     
    final class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        
        private let parent: DocumentScannerView
        
        init(parent: DocumentScannerView) {
            self.parent = parent
        }
         
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            DispatchQueue.main.async {
                let image = scan.imageOfPage(at: scan.pageCount - 1)
                self.parent.item = .Image(image)
                self.parent.dismiss()
            }
        }
         
        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            parent.dismiss()
        }
         
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            parent.dismiss()
        }
    }
}

