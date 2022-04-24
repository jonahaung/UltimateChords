//
//  LyricTextCreater.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 24/4/22.
//

import SwiftUI

struct LyricCreateText: View {
    
    @EnvironmentObject private var viewModel: LyricsCreaterViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            LyricsCreaterTextView()
            bottomBar()
        }
        
        .navigationBarItems(trailing: navLeading())
    }
    
    private func navLeading() -> some View {
        Button("Save") {
            viewModel.save()
        }
        .disabled(!viewModel.lyric.canSave)
    }
    private func bottomBar() -> some View {
        HStack {
            LyricImporterMenu()
            Spacer()
            Text("Preview").tapToPresent(LyricsViewerView(viewModel.lyric))
        }
        .padding(.horizontal)
        .padding(.vertical, 5)
    }
}
