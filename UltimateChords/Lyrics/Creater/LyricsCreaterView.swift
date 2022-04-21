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
        LyricImporterView {
            LyricsCreaterTextView(viewModel: viewModel)
        }
        .navigationBarItems(trailing: navTrailing())
        .environmentObject(viewModel)
    }
    
    private func navTrailing() -> some View {
        HStack {
            XIcon(.music_note_list)
                .tapToPresent(LyricCreaterControls(onSaved: onSaved))
            Text("Continue")
                .disabled(viewModel.lyric.text.isEmpty)
                .tapToPresent(LyricCreaterControls(onSaved: onSaved))
        }
    }
    
    private func onSaved() {
        viewModel.save()
        dismiss()
    }
}
