//
//  LyricsViewer.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 18/3/22.
//

import SwiftUI


struct LyricsViewerView: View {
    
    
    @EnvironmentObject private var lyric: Lyric
    @StateObject private var viewModel = LyricsViewerViewModel()
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                ScrollView([.horizontal], showsIndicators:  false) {
                    LazyHStack {
                        LyricsViewerTextView()
                            .frame(width: geo.size.width)
                            .environmentObject(viewModel)
                    }
                }
                bottomMenu()
            }
            .overlay(chordsView(), alignment: .leading)
            .navigationBarItems(trailing: NavTrailing())
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await viewModel.configure(lyric)
            }
            .onDisappear{
                lyric.updateLastView()
            }
            .activitySheet($viewModel.activityItem)
        }
    }
    
    
    private func bottomMenu() -> some View {
        HStack {
            Spacer()
            XIcon(.music_note_list)
                .font(.title)
                .tapToPresent(LyricViewerControls().environmentObject(viewModel))
            
        }.padding()
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
    
    
    private func chordsView() -> some View {
        Group {
            if viewModel.showChords, let song = lyric.song() {
                ChordsView(song: song)
                    .frame(width: ChordsView.frame.width + 6)
            }
        }
    }
}

