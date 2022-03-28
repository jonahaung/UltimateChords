//
//  PdfView.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 17/3/22.
//

import Foundation
import PDFKit
import SwiftUI

struct PdfView: UIViewRepresentable {
    
    typealias UIViewType = PDFView

    let data: Data
    let singlePage: Bool

    init(_ data: Data, singlePage: Bool = false) {
        self.data = data
        self.singlePage = singlePage
        
    }

    func makeUIView(context _: UIViewRepresentableContext<PdfView>) -> UIViewType {
        // Create a `PDFView` and set its `PDFDocument`.
        let pdfView = PDFView()
        pdfView.document = PDFDocument(data: data)
        pdfView.autoScales = true
        if singlePage {
            pdfView.displayMode = .singlePage
        }
        return pdfView
    }

    func updateUIView(_ pdfView: UIViewType, context _: UIViewRepresentableContext<PdfView>) {
        pdfView.document = PDFDocument(data: data)
    }
}
