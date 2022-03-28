//
//  LyricsCreaterView.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 22/3/22.
//

import SwiftUI

struct LyricsCreaterView: View {
    
    @StateObject private var viewModel = LyricsCreaterViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var showForm = false
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack {
                    if showForm {
                        Form{
                            Section {
                                TextField.init("Title", text: $viewModel.lyrics.title)
                                TextField.init("Artist", text: $viewModel.lyrics.artist)
                            }
                        }
                        .frame(width: geo.size.width, height: geo.size.height)
                        .transition(.move(edge: .bottom))
                    }
                    LyricsCreaterTextView()
                        .frame(width: geo.size.width, height: geo.size.height)
                        .environmentObject(viewModel)
                }.overlay(
                    Button {
                        withAnimation {
                            showForm.toggle()
                        }
                    } label: {
                        XIcon(showForm ? .square_and_pencil : .music_note_list)
                            .padding()
                    }.imageScale(.large)
                    , alignment: .topTrailing
                )
            }
        }
        .navigationBarTitle("Create")
        .navigationBarItems(trailing: TopBar())
    }
    
    private func TopBar() -> some View {
        HStack {
            Button {
                viewModel.save()
                dismiss()
            } label: {
                Text("Save")
            }
        }
        
    }
    
    private func BottomBar() -> some View {
        HStack {
            Spacer()
            Button{
                hideKeyboard()
            } label: {
                XIcon(.chevron_down)
            }
        }.padding()
    }
}
