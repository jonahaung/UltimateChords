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
        ImportableView {
            LyricsCreaterTextView(viewModel: viewModel)
        }
        .navigationBarItems(trailing: navTrailing())
        .environmentObject(viewModel)
    }
    
    private func navTrailing() -> some View {
        HStack(spacing: 0) {
            XIcon(.music_note)
                .tapToPresent(PickerNavigationView { LyricCreaterControls() })
            Button {
                viewModel.save()
               dismiss()
            } label: {
                Text("Save")
            }.disabled(viewModel.lyric.text.isWhitespace)
        }
    }
}
