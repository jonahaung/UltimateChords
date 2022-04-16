//
//  LyricCreaterControls.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 4/4/22.
//

import SwiftUI

struct LyricCreaterControls: View {
    
    @EnvironmentObject private var viewModel: LyricsCreaterViewModel
    
    var body: some View {
        Form {
            Section {
                TextField.init("Title", text: $viewModel.lyric.title)
                TextField.init("Artist", text: $viewModel.lyric.artist)
            }
            
            Section {
                Toggle("Editable", isOn: $viewModel.isEditable)
                Toggle("Preview", isOn: $viewModel.isPreviewMode)
                Button("Fill Demo Data") {
                    viewModel.fillDemoData()
                }
            }
        }
    }
}
