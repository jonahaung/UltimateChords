//
//  ContentView.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 15/3/22.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject private var viewModel = HomeViewModel()
    @StateObject private var searchViewModel = SearchViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.lyrics) {
                HomeCell(lyrics: Lyrics(cLyrics: $0))
            }
        }
        .task {
            viewModel.fetch()
        }
        .refreshable {
            viewModel.fetch()
        }
        .onChange(of: viewModel.documentString) { newValue in
            guard let newValue = newValue else { return }
            let song = ChordPro.parse(string: newValue)
            let lyrics = Lyrics(title: song.title ?? "", artist: song.artist ?? "", text: newValue)
            let cLycics = CLyrics.create(lyrics: lyrics)
            viewModel.lyrics.insert(cLycics, at: 0)
        }
        .overlay(SearchContent().environmentObject(searchViewModel))
        .searchable(text: $searchViewModel.searchText, prompt: Text("Title or Artist"))
        .navigationTitle("Home")
        .navigationBarItems(trailing: navTrailing())
    }
    
    private func navTrailing() -> some View {
        HStack {
            XIcon(.doc_text_viewfinder)
                .tapToPresent(DocumentPicker(fileContent: $viewModel.documentString))
            XIcon(.square_and_pencil)
                .tapToPush(LyricsCreaterView())
        }
    }
}

extension String: Identifiable {
    public var id: String { self }
    
    
}
