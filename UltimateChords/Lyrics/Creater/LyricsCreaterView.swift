//
//  LyricsCreaterView.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 22/3/22.
//

import SwiftUI

struct LyricsCreaterView: View {
    
    @StateObject private var viewModel = LyricsCreaterViewModel()
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        ImportableView {
            LyricsCreaterTextView()
        } onReceiveText: {
            viewModel.didImportText(text: $0)
        }
        .environmentObject(viewModel)
        .navigationBarTitle("Create")
        .navigationBarItems(trailing: navTrailing())
    }
    
    private func navTrailing() -> some View {
        HStack(spacing: 0) {
            XIcon(.music_note)
                .tapToPresent(PickerNavigationView { LyricCreaterControls() }.environmentObject(viewModel))
            Button {
                viewModel.save()
                DispatchQueue.main.async {
                    presentationMode.wrappedValue.dismiss()
                }
            } label: {
                Text("Save")
            }.disabled(viewModel.lyric.text.isWhitespace)
        }
    }
}
