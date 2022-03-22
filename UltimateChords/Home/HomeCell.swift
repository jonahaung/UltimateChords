//
//  LyricsTableViewCell.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 22/3/22.
//

import SwiftUI

struct HomeCell: View {
    
    let lyrics: Lyrics
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(lyrics.title)
                .font(XFont.font(.Medium, .Label))
            HStack {
                XIcon(.music_note)
                    .foregroundColor(.pink)
                Text(lyrics.artist)
            }
            .font(XFont.font(.Light, .Small))
        }
        .tapToPush(LyricsViewerView(lyrics))
    }
}
