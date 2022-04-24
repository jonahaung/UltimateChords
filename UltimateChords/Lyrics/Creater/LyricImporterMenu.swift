//
//  LyricImporterMenu.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 24/4/22.
//

import SwiftUI

struct LyricImporterMenu: View {
    
    @EnvironmentObject private var viewModel: LyricsCreaterViewModel
    
    var body: some View {
        Menu {
            ForEach(LyricImporterViewModel.Mode.allCases) { mode in
                Button(mode.description) {
                    viewModel.setImportMode(mode: mode)
                }
            }
        } label: {
            Text("Import")
        }
    }
}
