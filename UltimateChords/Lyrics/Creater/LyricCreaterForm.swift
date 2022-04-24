//
//  LyricCreaterForm.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 13/4/22.
//

import SwiftUI
import SwiftyChords

struct LyricCreaterForm: View {
    
    @EnvironmentObject private var viewModel: LyricsCreaterViewModel
    
    var body: some View {
        Form {
            Section("* Required Fields") {
                FormCell(icon: .doc_append) {
                    TextField("Song Title", text: $viewModel.lyric.title)
                }
                FormCell(icon: .music_mic) {
                    ArtistTextField(text: $viewModel.lyric.artist)
                }
            }
            
            Section("Instrument") {
                FormCell(icon: .tuningfork) {
                    Picker("Key", selection: $viewModel.lyric.key) {
                        ForEach(Chords.Key.allCases, id: \.self) { key in
                            Text(key.rawValue)
                                .tag(key.rawValue)
                        }
                    }
                }
                FormCell(icon: .metronome) {
                    TextField.init("Tempo", text: $viewModel.lyric.tempo)
                        .keyboardType(.numberPad)
                }
            }
            
            Section("Additional Informations") {
                FormCell(icon: .highlighter) {
                    TextField.init("Composer", text: $viewModel.lyric.composer)
                }
                FormCell(icon: .magazine) {
                    TextField.init("Album", text: $viewModel.lyric.album)
                }
                FormCell(icon: .calendar) {
                    TextField.init("Year", text: $viewModel.lyric.year)
                        .keyboardType(.numbersAndPunctuation)
                }
                FormCell(icon: .music_note_tv) {
                    Picker("Genre", selection: $viewModel.lyric.genre) {
                        ForEach(Genre.allCases, id: \.self) { genre in
                            Text(genre.rawValue)
                                .tag(genre.rawValue)
                        }
                    }
                }
                FormCell(icon: .link) {
                    TextField.init("Media Link", text: $viewModel.lyric.mediaLink)
                        .keyboardType(.URL)
                }
            }
            Section("Import") {
                Button("Import Chord-Pro files") {
                    viewModel.setImportMode(mode: .ChordPro_File)
                }
            }
            
            Section("Debug") {
                Button("Width Chords") {
                    viewModel.insertText(withChords)
                }
                Button("WidthOut Chords") {
                    viewModel.insertText(withoutChords)
                }
                Button("Hotel California") {
                    viewModel.lyric.title = "Hotel California"
                    viewModel.lyric.artist = "Eagles"
                    viewModel.insertText(hotelCalifornia)
                }
                Button("markdown") {
                    viewModel.lyric.title = "Markdown"
                    viewModel.lyric.artist = "Mark"
                    
                }
            }
        }
        .navigationBarItems(trailing: navTrailing())
    }
    
    private func navTrailing() -> some View {
        NavigationLink("Next", destination: {
            LyricCreateText()
        })
        .disabled(!viewModel.lyric.hasFilledForm)
    }
}
