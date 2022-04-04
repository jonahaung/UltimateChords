//
//  Pdf.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 17/3/22.
//

import PDFKit

struct Pdf {
    
    static func document(from attributedString: NSAttributedString) -> PDFDocument? {
        PDFDocument(url: url(from: attributedString))
    }
    
    static func url(from attributedString: NSAttributedString) -> URL {
        
        let mutable = attributedString.mutable
        mutable.adjustFontSize(to: XApp.PDF.A4.availiableWidth)
        
        let pdfRenderer = PDFDINA4PrintRenderer(pageSize: XApp.PDF.A4.size, margins: XApp.PDF.A4.margin)
        
        let printFormatter = UISimpleTextPrintFormatter(attributedText: mutable)
        pdfRenderer.addPrintFormatter(printFormatter, startingAtPageAt: 0)
        
        let documentURL = FileManager.default.temporaryDirectory.appendingPathComponent("jonahaung.pdf")
        
        do {
            try pdfRenderer.renderPDF(to: documentURL)
            return documentURL
        } catch {
            fatalError()
        }
    }
    
    static func createAttributedString(from url: URL) -> NSAttributedString? {
        if let pdf = PDFDocument(url: url) {
            let pageCount = pdf.pageCount
            let documentContent = NSMutableAttributedString()
            
            for i in 0 ..< pageCount {
                guard let page = pdf.page(at: i) else { continue }
                guard let pageContent = page.attributedString else { continue }
                documentContent.append(pageContent)
            }
            return documentContent
        }
        return nil
    }
}

class PDFDINA4PrintRenderer: UIPrintPageRenderer {
    
    private let pageSize: CGSize
    private let margins: UIEdgeInsets
    
    init(pageSize: CGSize, margins: UIEdgeInsets) {
        self.pageSize = pageSize
        self.margins = margins
    }
    override var paperRect: CGRect {
        return CGRect(origin: .zero, size: pageSize)
    }
    
    override var printableRect: CGRect {
        return paperRect.inset(by: margins)
    }
    
    func renderPDF(to url: URL) throws {
        prepare(forDrawingPages: NSMakeRange(0, numberOfPages))
        
        let graphicsRenderer = UIGraphicsPDFRenderer(bounds: paperRect)
        try graphicsRenderer.writePDF(to: url) { context in
            for pageIndex in 0..<numberOfPages {
                context.beginPage()
                drawPage(at: pageIndex, in: context.pdfContextBounds)
            }
        }
    }
}
