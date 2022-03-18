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
            TopBar()
            LyricsViewerTextView()
                .environmentObject(viewModel)
            BottomBar()
        }
    }
    
    private func TopBar() -> some View {
        HStack {
            PushBackButton()
            Spacer()
            Text("Edit")
                .tapToPush(LyricsEditorView(viewModel.lyrics).navigationBarHidden(true))
        }.padding(.horizontal)
    }
    
    private func BottomBar() -> some View {
        HStack {
            Stepper("") {
                viewModel.fontSize += 0.5
            } onDecrement: {
                viewModel.fontSize -= 0.5
            }.labelsHidden()

            Spacer()
            Menu("Export") {
                Button("PDF") {}
                Button("HTML") {}
            }
        }.padding(.horizontal)
    }
}

