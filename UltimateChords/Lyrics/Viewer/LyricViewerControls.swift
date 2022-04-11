//
//  LyricViewerControls.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 5/4/22.
//

import SwiftUI

struct LyricViewerControls: View {
    
    @Binding var isShowing: Bool
    
    @EnvironmentObject private var viewModel: LyricsViewerViewModel
    
    var body: some View {
        Form{
            Section{
                Button {
                    guard let song = viewModel.song else { return }
                    
                    let key = song.key ?? "C"
                    print(key)
                    
                    let mSong = PlainSong(AttributedString.defaultText(from: song).string)
                    if let newSong = mSong.transposed(fromString: key, toString: "B") {
                        let newText = newSong.lines.joined(separator: "\n")
                        viewModel.song?.rawText = newText
                        
                        
                    }
                    
                } label: {
                    Text("Transpose")
                }

                HStack {
                    Text("Transpose")
                    Spacer()
                    Button{
                        
                    }label: {
                        XIcon(.arrow_up_circle_fill)
                    }.buttonStyle(.borderless)
                    
                    Text("0")
                    
                    Button{
                        
                    }label: {
                        XIcon(.arrow_down_circle_fill)
                    }.buttonStyle(.borderless)
    
                }
            }
            Section {
                Picker("Text Display Mode", selection: $viewModel.displayMode) {
                    ForEach(UserDefault.LyricViewer.DisplayMode.allCases, id: \.self) { mode in
                        Text(mode.rawValue)
                            .tag(mode)
                    }
                }
                
                Toggle("Automatically adjust size", isOn: $viewModel.isDinamicFontSizeEnabled)
                    .toggleStyle(.switch)
                
                Toggle("Show Guitar Chords", isOn: $viewModel.showChords)
                    .toggleStyle(.switch)
            }
            
            Section {
                
                Button {
                    
                } label: {
                    HStack {
                        XIcon(.heart_fill)
                            .foregroundColor(.pink)
                        Text("Add to favourites")
                    }
                }
                Button {
                    
                } label: {
                    HStack {
                        XIcon(.star_fill)
                            .foregroundColor(.orange)
                        Text("Rate this lyric")
                    }
                }
                Button {
                    
                } label: {
                    HStack {
                        XIcon(.square_and_pencil)
                            .foregroundColor(.mint)
                        Text("Edit for yourself")
                    }
                }
                
                Button("Report this song") {
                    
                }
            }
            
            Section {
                Text("View as PDF Document")
                    .tapToPresent(PdfView(attributedText: viewModel.attributedText))
                Text("View as HTML Document")
                    .tapToPresent(HtmlView(song: viewModel.song ?? .init(rawText: "")))
            }
        }.refreshable {
            withAnimation(.interactiveSpring()) {
                isShowing = false
            }
        }
    }
}
