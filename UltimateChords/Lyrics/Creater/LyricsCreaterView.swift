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
            NavigationView {
                LyricCreaterForm()
                    .navigationBarItems(leading: navLeading())
                    .navigationBarTitleDisplayMode(.inline)
            }
            .navigationViewStyle(.stack)
            .onChange(of: viewModel.isSaved) { newValue in
                if newValue {
                    dismiss()
                }
            }
        }
        .environmentObject(viewModel)
        
    }
    
    
    private func navLeading() -> some View {
        Button("Cancel") {
            dismiss()
        }
    }
}
