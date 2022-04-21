//
//  PdfView.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 17/3/22.
//

import PDFKit
import SwiftUI

struct PdfView: UIViewRepresentable {
    
    typealias UIViewType = PDFView
    
    @State var attributedText: NSAttributedString
    
    func makeUIView(context _: UIViewRepresentableContext<PdfView>) -> UIViewType {
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous

        return pdfView
    }

    func updateUIView(_ pdfView: UIViewType, context _: UIViewRepresentableContext<PdfView>) {
        pdfView.document = Pdf.document(from: attributedText)
    }
}
