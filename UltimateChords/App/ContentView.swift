//
//  ContentView.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 15/3/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    var body: some View {
        NavigationView {
            List {
                ForEach(DemoSongs.allSongs, id: \.id) { song in
                    VStack(alignment: .leading) {
                        
                        Text(song.title)
                            .font(XFont.font(condense: .Condensed, weight: .Medium, size: .Label))
                
                        Text(song.artist.first ?? "")
                            .font(XFont.font(condense: .SemiCondensed, weight: .Regular, size: .Small))
                    }
                    .tapToPush(LyricsEditorView(song).navigationBarHidden(true))
                }
            }
        }
    }
}
