//
//  HomeViewModel.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 22/3/22.
//

import Combine
import SwiftUI
final class HomeViewModel: ObservableObject {
    
    @Published var lyrics = [Lyrics]()
    
    private var subscription: Set<AnyCancellable> = []
    @Published var searchText = String()
    
    init() {
        lyrics = CLyrics.all().map(Lyrics.init)
        $searchText
            .debounce(for: .milliseconds(800), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .compactMap{$0}
            .sink { _ in
                
            } receiveValue: { [self] text in
                searchItems(string: text)
            }
            .store(in: &subscription)
    }
    
    private func searchItems(string: String) {
        let cLyrics = CLyrics.all()
        if string.isEmpty {
            lyrics = cLyrics.map(Lyrics.init)
            return
        }
        lyrics = cLyrics.filter{ $0.title!.lowercased().contains(string.lowercased()) || $0.artist!.lowercased().contains(string.lowercased()) }.map(Lyrics.init)
    }
    
    func refreshable() {
        lyrics = CLyrics.all().map(Lyrics.init)
    }
}
