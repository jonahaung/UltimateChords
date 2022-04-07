//
//  KeyValueView.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 7/4/22.
//

import SwiftUI

struct SongKeyView: View {
    
    let song: Song?
    
    var body: some View {
        Group {
            if let key = song?.key {
                HStack(alignment: .lastTextBaseline, spacing: 1) {
                    Text("Key")
                        .font(.footnote)
                        .italic()
                        .foregroundStyle(.tertiary)
                    Text(key)
                        .font(.title3)
                        .tapToPresent(Text(key))
                }
            }
        }
    }
}
