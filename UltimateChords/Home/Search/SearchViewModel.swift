//
//  SearchViewModel.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 22/3/22.
//

import SwiftUI
import Combine

final class SearchViewModel: ObservableObject {

    @Published var results = [Lyric]()
    @Published var searchText = String()
    
    private var subscription: Set<AnyCancellable> = []
    
    init() {
        $searchText
            .debounce(for: .milliseconds(100), scheduler: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .compactMap{$0}
            .sink(receiveValue: { [weak self] text in
                self?.searchItems(string: text)
            })
            .store(in: &subscription)
    }
    
    private func searchItems(string: String) {
        guard !string.isEmpty else { results.removeAll(); return }
        withAnimation {
            results = CLyric.search(text: string).map{ Lyric.init(id: $0.id, title: $0.title.str, artist: $0.artist.str, text: $0.text.str)}
        }
    }
    
//    func search() {
//        if searchText.isEmpty {
//            results = Lyric.all()
//            return
//        }
//        results = Lyric.search(text: searchText)
//    }
}
