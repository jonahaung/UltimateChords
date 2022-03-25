//
//  LyricsViewer.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 18/3/22.
//

import SwiftUI

struct LyricsViewerView: View {

    @StateObject private var viewModel: LyricsViewerViewModel
    
    init(_ lyrics: Lyrics) {
        _viewModel = .init(wrappedValue: .init(lyrics))
    }
    
    var body: some View {
        VStack(spacing: .zero) {
            LyricsViewerTextView()
            BottomBar()
        }
        .environmentObject(viewModel)
        .navigationBarItems(trailing: NavTrailing())
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(item: $viewModel.pdfData) { data in
            PickerNavigationView {
                PdfView(data)
            }
        }
        .fullScreenCover(item: $viewModel.song) { song in
            PickerNavigationView {
                ViewSong(song: song)
            }
        }
    }
    
    private func NavTrailing() -> some View {
        HStack {
            Menu {
                Button("PDF") {
                    viewModel.makePDF()
                }
                Button("HTML") {
                    viewModel.makeHtml()
                }
            } label: {
                XIcon(.square_and_arrow_up)
            }
        }
    }
    
    private func BottomBar() -> some View {
        HStack {
            Button {
                viewModel.toggleSelect()
            } label: {
                XIcon(.music_quarternote_3)
            }
            Spacer()
        }.padding(.horizontal)
    }
}

