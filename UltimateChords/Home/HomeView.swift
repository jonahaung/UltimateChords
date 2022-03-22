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
        .refreshable {
            viewModel.fetch()
        }
        .overlay(SearchContent().environmentObject(searchViewModel))
        .searchable(text: $searchViewModel.searchText, prompt: Text("Title or Artist"))
        .navigationTitle("Home")
        .navigationBarItems(trailing: navTrailing())
    }
    
    private func navTrailing() -> some View {
        HStack {
            XIcon(.square_and_pencil)
                .tapToPush(LyricsCreaterView())
        }
    }
}

