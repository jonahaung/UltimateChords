// MARK: - View: Song View for macOS and iOS

/// HTML views for the song

import SwiftUI

struct ViewSong: View {
    
    
    @ObservedObject var song: Song
    @Environment(\.dismiss) private var dismiss
    @AppStorage("showChords") var showChords: Bool = true
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                WebView(htmlStgring: (song.html ?? ""))
                    .frame(maxHeight: .infinity)
                if showChords {
                    ViewChords(song: song)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Toggle("Chords", isOn: $showChords)
                        .toggleStyle(.switch)

                }
            }
        }
    }
    
    private func navTrailing() -> some View {
        HStack {
            Button("Save") {
                let x = CLyrics.create(lyrics: .init(title: song.title!, artist: song.artist!, text: song.rawText!))
                dismiss()
            }
        }
    }
}

struct ViewSongModifier: ViewModifier {
    
    @Binding var song: Song
    var string: String

    func body(content: Content) -> some View {
        content
            .task {
                song = ChordPro.parse(string: string)
            }
            .onChange(of: string) { new in
                song = ChordPro.parse(string: new)
            }
    }
}
