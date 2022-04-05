//
//  LyricViewerControls.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 5/4/22.
//

import SwiftUI

struct LyricViewerControls: View {
    
    @EnvironmentObject var viewModel: LyricsViewerViewModel
    
    
    var body: some View {
        PickerNavigationView {
            Form{
                Section{
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
                    Menu {
                        ForEach(LyricViewerService.DisplayMode.allCases, id: \.self) { mode in
                            Button(mode.rawValue) {
                                viewModel.setDisplayMode(mode)
                            }
                        }
                    } label: {
                        HStack {
                            Text("Text Display Mode")
                                .foregroundColor(.secondary)
                            Spacer()
                            Text(viewModel.displayMode.rawValue)
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
                        .tapToPresent(HtmlView(song: viewModel.getSong()!))
                }
            }
            .navigationTitle(viewModel.getSong()?.title ?? "")
        }
    }
}
