//
//  LyricsEditorView.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 15/3/22.
//

import SwiftUI

struct LyricsEditorView: View {
    
    
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var song: Song
    @StateObject private var manager: LyricsTextViewCoordinator
    
    init(_ song: Song) {
        _manager = .init(wrappedValue: LyricsTextViewCoordinator(song.lyrics))
        _song = .init(wrappedValue: song)
    }
    
    
    var body: some View {
        VStack {
            Color(uiColor: .systemBackground)
                .frame(height: 1)
            ScrollView(.vertical, showsIndicators: false) {
                topBar
                LyricsTextView()
                    .aspectRatio(21/29.7, contentMode: .fill)
                    .border(Color(uiColor: .opaqueSeparator), width: 1)
                    .padding(1)
                    .environmentObject(manager)
            }
        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                self.toolBar
            }
        }
        .sheet(item: $manager.htmlString) { html in
            WebView(htmlStgring: html)
                .padding()
        }
        .sheet(item: $manager.pdfData) { data in
            PdfView(data)
        }
    }
    
    private var toolBar: some View {
        HStack {
            Toggle("Edit", isOn: $manager.isEditable)
                .labelsHidden()
                .toggleStyle(.switch)
            Stepper("", value: $manager.fontSize).labelsHidden()
            Button("Detect") {
                manager.detect()
            }
            Button("PDF") {
                manager.makePDF()
            }
            Button("HTML") {
                manager.makeHtml()
            }
        }
    }
    
    private var topBar: some View {
        HStack {
            Button {
                presentationMode.wrappedValue.dismiss()
            }label: {
                Image(systemName: "chevron.left")
            }
            Text(song.title)
                .font(XFont.font(weight: .Medium, size: .System))
            Spacer()
            Text(song.artist.first ?? "")
                .font(XFont.font())
        }.padding(.horizontal)
            .onTapGesture {
                hideKeyboard()
            }
    }
}
