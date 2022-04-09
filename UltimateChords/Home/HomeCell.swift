//
//  LyricsTableViewCell.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 22/3/22.
//

import SwiftUI

struct HomeCell: View {
    
    let lyric: CreateLyrics
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(lyric.title)
                .font(XFont.headline(for: lyric.title).font)
            HStack {
                XIcon(.music_note)
                    .foregroundColor(.accentColor)
                Text(lyric.artist)
                
            }
            .font(XFont.universal(for: .footnote).font)
        }
        .tapToPush(LyricsViewerView(lyric).navigationBarHidden(true))
    }
}
