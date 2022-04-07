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
        .fullScreenCover(item: $viewModel.importMode) { mode in
            ImageImporterView(mode) { string in
                if let string = string {
                    viewModel.didImportText(text: string)
                }
            }
        }
    }
    
    private func navTrailing() -> some View {
        HStack {

            Toggle(isOn: $viewModel.isChordMode) {
                XIcon(.tuningfork)
            }
            XIcon(.music_note)
                .tapToPresent(PickerNavigationView { LyricCreaterControls() }.environmentObject(viewModel))
            XIcon(.square_and_arrow_down)
                .tapToShowComfirmationDialog {
                    ForEach(ImageImporter.Mode.allCases) { mode in
                        Button {
                            viewModel.importMode = mode
                        } label: {
                            Text(mode.description)
                        }
                    }
                }
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
