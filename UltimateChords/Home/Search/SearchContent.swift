//
//  SearchContent.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 22/3/22.
//

import SwiftUI

struct SearchContent: View {
    
    @EnvironmentObject private var viewModel: SearchViewModel
    @Environment(\.isSearching) private var isSearching
    
    var body: some View {
        Group {
            if isSearching {
                List {
                    Section(header: SearchTypeControl()) {
                        ForEach(viewModel.results) {
                            HomeCell(lyrics: $0)
                        }
                    }
                }
            }
        }
    }
    
    private func SearchTypeControl() -> some View {
        Picker("What is your favorite color?", selection: $viewModel.searchType) {
            ForEach(SearchViewModel.SearchType.allCases, id: \.self) { type in
                Text(type.rawValue)
                    .tag(type)
            }
        }
        .pickerStyle(.segmented)
        .labelsHidden()
    }
}

