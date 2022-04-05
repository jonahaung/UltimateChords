//
//  PDFScannerView.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 5/4/22.
//

import SwiftUI
import IRLPDFScanContent
struct PDFScannerView: View {
    @ObservedObject var scanner: IRLPDFScanContent = IRLPDFScanContent()
            
        var body: some View {
            VStack() {
                 if let latestScan = scanner.latestScan {
                    latestScan.swiftUIPDFView
                    
                } else {
                    Text("Press the Scan button")
                }
            }
            .padding()
            .navigationBarItems(trailing: Button("Scan", action: {
                scanner.present(animated: true, completion: nil)
            }))
        }
}
