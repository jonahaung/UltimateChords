//
//  Pdf.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 17/3/22.
//

import PDFKit

struct Pdf {
    
    static func createPdf(from attributedString: NSAttributedString) -> URL? {
        let pdfRenderer = PDFDINA4PrintRenderer()
        let printFormatter = UISimpleTextPrintFormatter(attributedText: attributedString)
        pdfRenderer.addPrintFormatter(printFormatter, startingAtPageAt: 0)
        let documentURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("ultimateChord.pdf")
       
        do {
            try pdfRenderer.renderPDF(to: documentURL)
            return documentURL
        } catch {
            print(error)
            return nil
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

    let pageSize = CGSize(width: 595, height: 842)

    override var paperRect: CGRect {
        return CGRect(origin: .zero, size: pageSize)
    }

    override var printableRect: CGRect {
        let pageMargin: CGFloat = 60
        let margins = UIEdgeInsets(top: pageMargin, left: pageMargin, bottom: pageMargin, right: pageMargin)
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

extension Data: Identifiable {
    public var id: Data {
        self
    }
    
    
}
