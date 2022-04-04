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
                TextField.init("Title", text: $viewModel.tempSong.title)
                TextField.init("Artist", text: $viewModel.tempSong.artist)
            }
            
            Section {
                Toggle("Editable", isOn: $viewModel.isEditable)
                Button("Fill Demo Data") {
                    viewModel.fillDemoData()
                }
            }
        }
    }
}
