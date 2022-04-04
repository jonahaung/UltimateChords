//
//  WebView.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 17/3/22.
//

import SwiftUI
import WebKit
 
struct HtmlView: UIViewRepresentable {
 
    var song: Song?
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
 
    func updateUIView(_ webView: WKWebView, context: Context) {
        if let song = song {
            webView.loadHTMLString(Html.parse(from: song), baseURL: nil)
        }
    }
}
