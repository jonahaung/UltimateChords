//
//  ContentView.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 15/3/22.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationView {
            List {
                ForEach(DemoSongs.allSongs, id: \.id) { lyrics in
                    VStack(alignment: .leading) {
                        Text(lyrics.title)
                            .font(XFont.font(.Medium, .Label))
                
                        Text(lyrics.artist.first ?? "")
                            .font(XFont.font(.Light, .Small))
                    }
                    .tapToPush(LyricsViewerView(lyrics).navigationBarHidden(true))
                }
                
                
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
