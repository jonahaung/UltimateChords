//
//  ContentView.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 15/3/22.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.lyrics) {
                HomeCell(lyrics: $0)
            }
        }
        .navigationTitle("Lyrics Myanmar")
        .searchable(text: $viewModel.searchText) {
            ForEach(viewModel.lyrics) { lyrics in
                Text(lyrics.title).searchCompletion(lyrics.title)
            }
        }
        .navigationBarItems(trailing: navTrailing())
        .refreshable {
            viewModel.refreshable()
        }
    }
    
    private func navTrailing() -> some View {
        HStack {
            XIcon(.square_and_pencil)
                .tapToPush(LyricsCreaterView())
        }
    }
}
