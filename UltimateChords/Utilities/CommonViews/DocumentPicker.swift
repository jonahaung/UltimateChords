//
//  DocumentPicker.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 25/3/22.
//

import Foundation
import SwiftUI
import UIKit
import VisionKit


struct DocumentPicker: UIViewControllerRepresentable {
    
    @Binding var fileContent: String?
    
    func makeCoordinator() -> DocumentPicker.Coordinator {
        return DocumentPicker.Coordinator(parent1: self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentPicker>) -> UIDocumentPickerViewController {
        
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.item])
        picker.allowsMultipleSelection = false
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: DocumentPicker.UIViewControllerType, context: UIViewControllerRepresentableContext<DocumentPicker>) {
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        
        var parent: DocumentPicker
        
        init(parent1: DocumentPicker){
            parent = parent1
        }
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            let url = urls[0]
           
            guard url.startAccessingSecurityScopedResource() else {
                    print("can't access")
                    return
            }
            defer {
                url.stopAccessingSecurityScopedResource()
            }
            do {
                let text = try String(contentsOf: url, encoding: .utf8)
                DispatchQueue.main.async {
                    self.parent.fileContent = text
                }
            } catch {
                    print(error)
            }
        }
    }
}
