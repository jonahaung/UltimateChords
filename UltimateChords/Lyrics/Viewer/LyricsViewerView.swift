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
        .navigationBarItems(trailing: NavTrailing())
    }
    
    private func NavTrailing() -> some View {
        HStack {
            Menu {
                Button("PDF") {}
                Button("HTML") {}
            } label: {
                XIcon(.square_and_arrow_up)
            }
            
        }
    }
    
    private func BottomBar() -> some View {
        HStack {
            Spacer()
            XIcon(.pencil)
                .tapToPush(LyricsEditorView(viewModel.getLyrics()).navigationBarHidden(true))
        }
    }
}
