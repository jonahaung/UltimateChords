//
//  LyricsViewer.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 18/3/22.
//

import SwiftUI

struct LyricsViewerView: View {
    
    @StateObject private var viewModel: LyricsViewerViewModel
    
    init(_ lyrics: Lyrics) {
        _viewModel = .init(wrappedValue: .init(lyrics))
    }
    
    var body: some View {
        VStack {
            
            LyricsViewerTextView()
                .environmentObject(viewModel)
            BottomBar()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(leading: NavLeading(), trailing: NavTrailing())
        .sheet(item: $viewModel.pdfData) { data in
            PdfView(data)
        }
        .task {
            viewModel.detect()
        }
    }
    private func NavLeading() -> some View {
        HStack {
            
        }
    }
    
    private func NavTrailing() -> some View {
        HStack {
            Menu {
                Button("PDF") {
                    viewModel.makePDF()
                }
                Button("HTML") {}
            } label: {
                XIcon(.square_and_arrow_up)
            }
            
        }
    }
    
    private func BottomBar() -> some View {
        HStack {
            Button {
                viewModel.detect()
            } label: {
                Text("Detect")
            }

            Spacer()
            XIcon(.pencil)
                .tapToPush(LyricsEditorView(viewModel.lyrics).navigationBarHidden(true))
        }.padding()
    }
}

