//
//  LyricsViewer.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 18/3/22.
//

import SwiftUI


struct LyricsViewerView: View {
    
    
    @StateObject private var viewModel = LyricsViewerViewModel()
    private var lyric: Lyric
    
    init(_ lyric: Lyric) {
        self.lyric = lyric
    }
    
    var body: some View {
        VStack(spacing: 0) {
            NavBar {
                SongKeyView(song: viewModel.song)
                Spacer()
                shareButton()
            }
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    titleView()
                        .padding(.horizontal, 8)
                    if viewModel.showChords, let song = viewModel.song {
                        ChordsView(song: song)
                    }
                    ScrollView(.horizontal, showsIndicators: false) {
                        LyricsViewerTextView()
                    }
                }
            }
        }
        .overlay(bottomMenu(), alignment: .bottomTrailing)
        .activitySheet($viewModel.activityItem)
        .environmentObject(viewModel)
        .task {
            viewModel.configure(lyric)
        }
    }
    

    private func titleView() -> some View {
        Text(lyric.title.whiteSpace)
            .font(XFont.title(for: lyric.title).font)
        +
        Text(lyric.artist.nonLineBreak)
            .font(XFont.universal(for: .subheadline).font)
            .foregroundColor(.secondary)
    }
    
    private func bottomMenu() -> some View {
        XIcon(.music_note_list)
            .font(.title)
            .padding()
            .tapToPresent(LyricViewerControls())
    }
    
    private func shareButton() -> some View {
        Menu {
            Button("Export as PDF") {
                viewModel.activityItem = .init(items: Pdf.url(from: viewModel.attributedText))
            }
            Button("Export Plain Text") {
                viewModel.activityItem = .init(items: viewModel.attributedText.string)
            }
            Button("Copy Texts") {
                UIPasteboard.general.string = viewModel.attributedText.string
            }
            Button("Print Page") {
                
            }
        } label: {
            XIcon(.square_and_arrow_up)
                .padding()
        }
    }
}

