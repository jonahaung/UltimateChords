//
//  LyricsViewer.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 18/3/22.
//

import SwiftUI


struct LyricsViewerView: View {
    
    let lyric: Lyric
    @StateObject private var viewModel = LyricsViewerViewModel()
    
    var body: some View {
        GeometryReader { geo in
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(alignment: .leading, spacing: 0) {
                    
                    if viewModel.showControls {
                        LyricViewerControls()
                            .frame(height: geo.frame(in: .global).height)
                            .transition(.move(edge: .bottom))
                    } else {
                        titleView()
                        ScrollView(.horizontal, showsIndicators: false) {
                            LyricsViewerTextView()
                                .activitySheet($viewModel.activityItem)
                        }
                        .transition(.move(edge: .bottom))
                    }
                }
            }
            .frame(width: geo.size.width)
            .overlay(bottomMenu(), alignment: .bottomTrailing)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: NavTrailing())
            .environmentObject(viewModel)
            .task {
                await viewModel.configure(lyric)
            }
            
        }
        
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
    
    private func NavTrailing() -> some View {
        XIcon(.square_and_arrow_up)
            .tapToShowComfirmationDialog {
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
            }
    }
    
    private func titleView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .lastTextBaseline) {
                Text(lyric.title.whiteSpace)
                    .font(.init(XFont.title(for: lyric.title)))
                +
                Text(lyric.artist.nonLineBreak.whiteSpace)
                    .font(XFont.universal(for: .footnote).font)
                    .foregroundColor(.secondary)
                +
                
                Text((viewModel.song?.album?.prepending("[").appending("]").nonLineBreak ?? String()))
                    .font(XFont.universal(for: .footnote).font)
                    .foregroundColor(.secondary)
            }
            
            SongKeyView(song: viewModel.song)
            
            if viewModel.showChords {
                ChordsView(song: viewModel.song ?? .init(rawText: ""))
            }
        }
        .padding(.horizontal, 5)
        .padding(.top)
        .transition(.move(edge: .leading))
    }
}

