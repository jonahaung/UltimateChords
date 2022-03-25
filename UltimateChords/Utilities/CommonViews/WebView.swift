//
//  WebView.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 17/3/22.
//

import SwiftUI
import WebKit
 
struct WebView: UIViewRepresentable {
 
    var htmlStgring: String
 
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
 
    func updateUIView(_ webView: WKWebView, context: Context) {
        webView.loadHTMLString(htmlStgring, baseURL: nil)
    }
}

extension NSAttributedString {
    func toHtml() -> String? {
        let documentAttributes = [NSAttributedString.DocumentAttributeKey.documentType: NSAttributedString.DocumentType.html]
        do {
            let htmlData = try self.data(from: NSMakeRange(0, self.length), documentAttributes:documentAttributes)
            if let htmlString = String(data:htmlData, encoding:String.Encoding.utf8) {
                return htmlString
            }
        }
        catch {
            print("error creating HTML from Attributed String")
        }
        return nil
    }
}
