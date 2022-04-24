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
           
            Section(footer: singerTagViews()) {
                ForEach(viewModel.lyrics) {
                    HomeCell(lyric: $0)
                }
                .onDelete(perform: self.deleteItems)
            }
        }
        .task {
            viewModel.task()
        }
        .refreshable {
            viewModel.refresh()
        }
        .overlay(SearchContent().environmentObject(searchViewModel))
        .searchable(text: $searchViewModel.searchText, prompt: Text("Title or Artist"))
        .navigationTitle("Home")
        .navigationBarItems(trailing: navTrailing())
    }
    private func singerTagViews() -> some View {
        AutoWrap(Singers.allSingers, id: \.self, vSpacing: 5, hSpacing: 5) { singer in
            Tag(singer, bgcolor: XColor.Tag.random())
        }
    }
    private func navTrailing() -> some View {
        HStack {
            XIcon(.square_and_pencil)
                .tapToPresent( LyricsCreaterView() , .FullScreen)
        }
    }
    
   
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { viewModel.lyrics[$0] }.forEach {
                if let x = CLyric.cLyrics(for: $0.id) {
                    Persistence.shared.context.delete(x)
                    Persistence.shared.save()
                    viewModel.refresh()
                }
            }
        }
    }
}

