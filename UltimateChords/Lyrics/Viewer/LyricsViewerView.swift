//
//  LyricsViewer.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 18/3/22.
//

import SwiftUI

extension LyricsViewerView {
    enum ViewerMode: String, Identifiable, CaseIterable {
        var id: ViewerMode {self}
        case PDFView, HtmlView, TextView
    }
}

struct LyricsViewerView: View {
    
    @AppStorage("LyricsViewerView.mainVierMode") private var mainVierMode = ViewerMode.TextView.rawValue
    @AppStorage("LyricsViewerView.showControls") private var showControls = false
    @AppStorage("LyricsViewerView.showChords") private var showChords = false
    @State private var fullScreenItem: ViewerMode?
    
    @EnvironmentObject private var lyric: Lyric
    @StateObject private var viewModel = LyricsViewerViewModel()
    
    var body: some View {
        lyricView(for: ViewerMode(rawValue: mainVierMode)!)
            .overlay(chordsView(), alignment: .leading)
            .overlay(overlaySideMenu(), alignment: .trailing)
            .navigationBarItems(leading: NavLeading(), trailing: NavTrailing())
            .navigationBarTitleDisplayMode(.inline)
            .fullScreenCover(item: $fullScreenItem) { item in
                PickerNavigationView {
                    lyricView(for: item)
                }
            }
            .task {
                await viewModel.configure(lyric)
            }
            .onDisappear{
                lyric.updateLastView()
            }
    }
    
    private func overlaySideMenu() -> some View {
        Group {
            if showControls {
                VStack(spacing: 10) {
                    Menu {
                        ForEach(ViewerMode.allCases) { mode in
                            Button(mode.rawValue) {
                                fullScreenItem = mode
                            }
                        }
                    } label: {
                        XIcon(.square_and_arrow_up)
                    }
                    
                    Toggle(isOn: $viewModel.isDinamicFontSizeEnabled) {
                        XIcon(.textformat_size)
                    }
                    .toggleStyle(.button)
                    .background()
                    
                    
                    Toggle(isOn: $showChords) {
                        XIcon(.guitars)
                    }
                    .toggleStyle(.button)
                    .background()
                    
                    Menu {
                        ForEach(Song.DisplayMode.allCases, id: \.self) { mode in
                            Button(mode.rawValue) {
                                viewModel.song?.setDisplayMode(mode)
                            }
                        }
                    } label: {
                        XIcon(.text_viewfinder)
                    }
                    
                    
                }
                .font(.system(size: 20, weight: .semibold))
                .padding(.trailing)
            }
        }
    }
    
    private func NavTrailing() -> some View {
        HStack {
            Picker("", selection: $mainVierMode) {
                ForEach(ViewerMode.allCases, id: \.self) { mode in
                    Text(mode.rawValue).tag(mode.rawValue)
                }
            }
            .labelsHidden()
        
            Toggle(isOn: $showControls) {
                XIcon(.music_note)
            }
        }
    }
    private func NavLeading() -> some View {
        Group {
            
        }
    }
    
    private func lyricView(for mode: ViewerMode) -> some View {
        Group {
            switch mode {
            case .PDFView:
                PdfView(attributedText: viewModel.song?.attributedText)
            case .HtmlView:
                HtmlView(song: lyric.song())
            case .TextView:
                LyricsViewerTextView()
                    .environmentObject(viewModel)
            }
        }
    }
    
    private func chordsView() -> some View {
        Group {
            if showChords, let song = lyric.song() {
                ChordsView(song: song)
                    .frame(width: ChordsView.frame.width + 6)
            }
        }
    }
}

