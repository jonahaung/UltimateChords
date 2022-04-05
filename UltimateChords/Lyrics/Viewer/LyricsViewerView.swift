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
    
    @State private var item: ActivityItem?
    @EnvironmentObject private var lyric: Lyric
    @StateObject private var viewModel = LyricsViewerViewModel()
    
    var body: some View {
        lyricView(for: ViewerMode(rawValue: mainVierMode)!)
            .overlay(chordsView(), alignment: .leading)
            .overlay(overlaySideMenu(), alignment: .trailing)
            .navigationBarItems(leading: NavLeading(), trailing: NavTrailing())
            .navigationBarTitleDisplayMode(.inline)
            .fullScreenCover(item: $fullScreenItem) { x in
                PickerNavigationView {
                    lyricView(for: x)
                }
            }
            .task {
                await viewModel.configure(lyric)
            }
            .onDisappear{
                lyric.updateLastView()
            }
    }
    
    private func getItems() -> [Any] {
        guard let fullScreenItem = fullScreenItem else {
            return []
        }
        
        var items = [Any]()
        switch fullScreenItem {
        case .PDFView:
            items.append(Pdf.url(from: viewModel.attributedText))
        case .HtmlView:
            items.append(Html.parse(from: viewModel.getSong() ?? Song.init(rawText: lyric.text!)))
        case .TextView:
            items.append(viewModel.attributedText.mutable)
        }
        return items
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
                    Button {
                        item = ActivityItem(
                            items: Pdf.url(from: viewModel.attributedText)
                        )
                    } label: {
                        Text("PDF")
                    }
                    .activitySheet($item)
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
                        ForEach(LyricViewerService.DisplayMode.allCases, id: \.self) { mode in
                            Button(mode.rawValue) {
                                viewModel.setDisplayMode(mode)
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
                PdfView(attributedText: viewModel.attributedText)
            case .HtmlView:
                HtmlView(song: viewModel.getSong() ?? .init(rawText: lyric.text!))
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

