//
//  LyricCreaterControls.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 4/4/22.
//

import SwiftUI
import SwiftyChords

struct LyricCreaterControls: View {
    
    @EnvironmentObject private var viewModel: LyricsCreaterViewModel
    var onSaved: () -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        PickerNavigationView {
            Form {
                Section("Required Informations") {
                    TextField.init("Song Title", text: $viewModel.lyric.title)
                    TextField.init("Singer / Artist", text: $viewModel.lyric.artist)
                    Picker("Key", selection: $viewModel.lyric.key) {
                        ForEach(Chords.Key.allCases.map{$0.rawValue}) { key in
                            Text(key)
                                .tag(key)
                        }
                    }
                }
                Section("Additional Informations") {
                    TextField.init("Composer", text: $viewModel.lyric.composer)
                    TextField.init("Album", text: $viewModel.lyric.album)
                    TextField.init("Year", text: $viewModel.lyric.year)
                        .keyboardType(.numberPad)
                    Picker("Genre", selection: $viewModel.lyric.genre) {
                        ForEach(Genre.allCases) {
                            Text($0.description)
                                .tag($0.rawValue)
                        }
                    }
                }
                Section("Controls") {
                    Toggle("Editable", isOn: $viewModel.isEditable)
                    Button("Fill Demo Data") {
                        viewModel.fillDemoData()
                    }
                }
            }
            .navigationBarItems(trailing: saveButton())
        }
    }
    
    private func saveButton() -> some View {
        Button("Save") {
            dismiss()
            onSaved()
        }
        .disabled(!viewModel.lyric.canSave)
    }
}
