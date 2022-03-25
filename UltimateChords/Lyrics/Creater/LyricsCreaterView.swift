//
//  LyricsCreaterView.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 22/3/22.
//

import SwiftUI

struct LyricsCreaterView: View {
    private enum Field: Int, Hashable {
        case Artist, Title, Lyrics
    }
    @StateObject private var viewModel = LyricsCreaterViewModel()
    @FocusState private var field: Int?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            if viewModel.canInputLyrics {
                LyricsCreaterTextView()
                    .environmentObject(viewModel)
            } else {
                Form {
                    Section {
                        HStack {
                            XIcon(.music_quarternote_3)
                                .foregroundColor(.pink)
                            TextField("Title", text: $viewModel.lyrics.title)
                                .focused($field, equals: 0)
                        }
                    
                        HStack {
                            XIcon(.music_quarternote_3)
                                .foregroundColor(.pink)
                            TextField("Artist", text: $viewModel.lyrics.artist)
                                .focused($field, equals: 1)
                        }
                        
                    }
                }
                .task {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        field = 0
                    }
                }
                .onSubmit {
                    if viewModel.isValidArtist() {
                        viewModel.canInputLyrics = true
                    } else {
                        field! += 1
                    }
                }
            }
        }
        .navigationBarTitle(viewModel.canInputLyrics ? viewModel.lyrics.title : "", displayMode: .inline)
        .navigationBarItems(trailing: TopBar())
    }
    
    private func TopBar() -> some View {
        HStack {
            Button {
                if viewModel.canInputLyrics {
                    viewModel.save()
                    dismiss()
                } else if viewModel.isValidArtist() {
                    viewModel.canInputLyrics = true
                }
            } label: {
                Text(viewModel.canInputLyrics ? "Save" : "Continue")
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
