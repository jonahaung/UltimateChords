//
//  HomeViewModel.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 22/3/22.
//


import SwiftUI

final class HomeViewModel: ObservableObject {
    @Published var lyrics = [Lyric]()
    private var hasLoaded = false
    
    func task() {
        lyrics = CLyric.all().map{ Lyric.init(id: $0.id, title: $0.versionTitle, artist: $0.artist.str, text: $0.text.str)}
    }
    func refresh() {
        hasLoaded = false
        task()
    }
}
