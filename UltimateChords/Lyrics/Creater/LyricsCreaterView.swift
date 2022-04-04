//
//  LyricsCreaterView.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 22/3/22.
//

import SwiftUI
import SwiftyChords
struct LyricsCreaterView: View {
    
    @StateObject private var viewModel = LyricsCreaterViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var chordText = ""
    @FocusState private var isUsernameFocused: Bool
    
    var body: some View {
        VStack {
            LyricsCreaterTextView()
                .environmentObject(viewModel)
            
            if viewModel.showChordPicker {
                ChordPicker(chord: $viewModel.chord)
            }
        }
        .navigationBarTitle("Create")
        .navigationBarItems(trailing: navTrailing())
    }
    
    private func navTrailing() -> some View {
        HStack {
            Toggle(isOn: $viewModel.isChordMode) {
                XIcon(.tuningfork)
            }
            XIcon(.music_note)
                .tapToPresent(PickerNavigationView { LyricCreaterControls() }.environmentObject(viewModel))
            Button {
                viewModel.save()
                dismiss()
            } label: {
                Text("Save")
            }
        }
        
    }
    
    private func BottomBar() -> some View {
        HStack {
            Spacer()
            Button{
                hideKeyboard()
            } label: {
                XIcon(.chevron_down)
            }
        }.padding()
    }
}
