//
//  LyricsViewer.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 18/3/22.
//

import SwiftUI

struct LyricsViewerView: View {
    
    @StateObject private var viewModel: LyricsViewerViewModel
    @State private var showControls = false
    @State private var showChords = false
    
    init(_ lyrics: Lyrics) {
        _viewModel = .init(wrappedValue: .init(lyrics))
    }
    
    var body: some View {
        VStack {
            LyricsViewerTextView()
                .overlay(overlaySideMenu(), alignment: .trailing)
                .overlay(overlayBottomMenu(), alignment: .bottom)
            if showChords {
                if let song = viewModel.song {
                    chordsView(song)
                        .transition(.scale)
                    Divider()
                }
            }
        }
        .overlay(floatingMenu(), alignment: .bottomTrailing)
        .navigationBarItems(trailing: NavTrailing())
        .navigationBarTitleDisplayMode(.inline)
        .environmentObject(viewModel)
        .fullScreenCover(item: $viewModel.viewType) {
            fullScreenCover($0)
        }
        .task {
            await viewModel.loadSong()
        }
    }
    
    
    private func NavTrailing() -> some View {
        HStack {
            Menu {
                Button("PDF") {
                    viewModel.viewType = .Pdf
                }
                Button("HTML") {
                    viewModel.viewType = .Html
                }
            } label: {
                XIcon(.square_and_arrow_up)
            }
        }
    }
    
    private func floatingMenu() -> some View {
        Toggle(isOn: $showControls, label: {
            XIcon(.music_note_list)
                .font(.title3)
        }).padding().toggleStyle(.button)
        
    }
    private func overlayBottomMenu() -> some View {
        Group {
            if showControls {
                HStack {
                    Toggle("Show Chords", isOn: $showChords).labelsHidden()
                    Slider(value: $viewModel.zoom, in: .init(uncheckedBounds: (lower: 0.5, upper: 1.5)))
                }
                .padding(.leading)
                
            }
        }
    }
    private func overlaySideMenu() -> some View {
        Group {
            if showControls {
                VStack {
                    Spacer()
                    Button {
                        
                    } label: {
                        XIcon(showControls ? .square_and_pencil : .music_note_list)
                    }.padding()
                    
                    
                    Button("PDF") {
                        viewModel.viewType = .Pdf
                    }.padding()
                    
                    Button("HTML") {
                        viewModel.viewType = .Html
                    }.padding()
                    
                    Button {
                        viewModel.toggleSelect()
                    } label: {
                        XIcon(.music_quarternote_3)
                    }.padding()
                    
                    Spacer()
                }.font(.system(size: 18, weight: .semibold))
            }
        }
    }
    
    private func fullScreenCover(_ type: LyricsViewerViewModel.ViewType) -> some View {
        Group {
            switch type {
            case .Pdf:
                PickerNavigationView {
                    if let song = viewModel.song {
                        PdfView(song.pdfData)
                    }
                }
            case .Html:
                PickerNavigationView {
                    if let song = viewModel.song {
                        HtmlView(htmlStgring: song.html)
                    }
                }
            case .Text:
                EmptyView()
            }
        }
    }
    
    private func chordsView(_ song: Song) -> some View {
        ViewChords(song: song)
    }
}

