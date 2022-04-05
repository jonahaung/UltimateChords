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
                    Section {
                        ForEach(viewModel.results) {
                            HomeCell(lyric: $0)
                        }
                    }
                }
            }
        }
    }
}

