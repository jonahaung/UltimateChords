// MARK: - View: Chords View for macOS and iOS

/// Show chord diagrams

import SwiftUI
import SwiftyChords

struct ChordsView: View {
    var song: Song
    static let frame = CGRect(x: 0, y: 0, width: 100, height: 150)
    static let chordsDatabase = Chords.guitar
    @State var showChordSheet = false
    @State var selectedChord: Chord?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                ForEach(song.chords.sorted { $0.name < $1.name }) { chord in
                    if let chordPosition = ChordsView.chordsDatabase.filter { $0.key == chord.key && $0.suffix == chord.suffix}, let layer = chordPosition.first?.shapeLayer(rect: ChordsView.frame, showFingers: true, showChordName: true), let image = layer.image()?.withRenderingMode(.alwaysTemplate) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .tapToPresent(ChordsSheet(chord: chord), .Sheet)
                            .foregroundStyle(.secondary)
                            .frame(width:ChordsView.frame.width, height: ChordsView.frame.height)
                    }
                }
            }
        }
    }
}

struct ChordsSheet: View {
    @Environment(\.presentationMode) var presentationMode
    var chord: Chord?
    var body: some View {
        let chordPosition = Chords.guitar.matching(key: chord!.key).matching(suffix: chord!.suffix)
        VStack {
            Text("Chord: \(chord!.key.rawValue)\(chord!.suffix.rawValue)")
                .font(.title)
            ScrollView {
                LazyVGrid(
                    columns: [GridItem(.adaptive(minimum: 110))],
                    alignment: .center,
                    spacing: 4,
                    pinnedViews: [.sectionHeaders, .sectionFooters]
                ) {
                    ForEach(chordPosition) { chord in
                        let frame = CGRect(x: 0, y: 0, width: 120, height: 180) // I find these sizes to be good.
                        let layer = chord.shapeLayer(rect: frame, showFingers: true, showChordName: false)
                        let image = layer.image() // might be exepensive. Use CALayer when possible.
#if os(macOS)
                        Image(nsImage: image!)
                            .rotation3DEffect(.degrees(180), axis: (x: 1, y: 0, z: 0))
#endif
#if os(iOS)
                        Image(uiImage: image!)
#endif
                    }
                }
            }
            Button(
                action: {
                    presentationMode.wrappedValue.dismiss()
                },
                label: {
                    Text("Close")
                }
            )
            .keyboardShortcut(.defaultAction)
        }
        .padding()
        .frame(minWidth: 400, idealWidth: 400, minHeight: 400, idealHeight: 400)
    }
}
