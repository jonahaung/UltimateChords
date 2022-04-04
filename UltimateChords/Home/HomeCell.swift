//
//  LyricsTableViewCell.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 22/3/22.
//

import SwiftUI

struct HomeCell: View {
    
    let lyric: Lyric
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(lyric.title )
                .font(XFont.headline(for: lyric.title ).font)
            HStack {
                XIcon(.music_note)
                    .foregroundColor(.pink)
                Text(lyric.artist )
            }
            .font(XFont.footnote(for: lyric.artist ).font)
        }
        .tapToPush(LyricsViewerView().environmentObject(lyric))
    }
}
