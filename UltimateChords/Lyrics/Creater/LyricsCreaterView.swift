//
//  LyricsCreaterView.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 22/3/22.
//

import SwiftUI

struct LyricsCreaterView: View {
    
    @StateObject private var viewModel = LyricsCreaterViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ImportableView { text in
            viewModel.insertText(SongParser.convert(text))
        } content: {
            LyricsCreaterTextView(viewModel: viewModel)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: navTrailing())
        .task {
            viewModel.task()
        }
    }
    
    private func navTrailing() -> some View {
        HStack(spacing: 0) {
            XIcon(.music_note)
                .tapToPresent(PickerNavigationView { LyricCreaterControls() }.environmentObject(viewModel))
            Button {
                viewModel.save()
               dismiss()
            } label: {
                Text("Save")
            }.disabled(viewModel.lyric.text.isWhitespace)
        }
    }
}
