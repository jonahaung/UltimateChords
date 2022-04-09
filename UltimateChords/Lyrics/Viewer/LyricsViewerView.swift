//
//  LyricsViewer.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 18/3/22.
//

import SwiftUI


struct LyricsViewerView: View {
    
    
    @StateObject private var viewModel = LyricsViewerViewModel()
    private var lyric: CreateLyrics
    
    init(_ lyric: CreateLyrics) {
        self.lyric = lyric
    }
    
    var body: some View {
        VStack(spacing: 0) {
            NavBar {
                SongKeyView(song: viewModel.song)
                Spacer()
                shareButton()
            }
            ScrollView([.horizontal, .vertical], showsIndicators: false) {
                ScrollViewReader { scrollView in
                    if viewModel.showChords {
                        ChordsView(song: viewModel.song ?? .init(rawText: ""))
                    }
                    LyricsViewerTextView()
                        .id(0)
                        .task {
                            viewModel.configure(lyric)
                            scrollView.scrollTo(0, anchor: .topLeading)
                        }
                }
            }
            
            if viewModel.showControls {
                Divider()
                LyricViewerControls(isShowing: $viewModel.showControls)
                    .transition(.move(edge: .bottom))
            }
        }
        .environmentObject(viewModel)
        .activitySheet($viewModel.activityItem)
        .overlay(bottomMenu(), alignment: .bottomTrailing)
    }
    
    
    private func bottomMenu() -> some View {
        Button {
            withAnimation {
                viewModel.showControls.toggle()
            }
        } label: {
            XIcon(.music_note_list)
                .font(.title)
                .padding()
        }
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

