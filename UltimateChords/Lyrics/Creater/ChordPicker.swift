//
//  ChordPicker.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 4/4/22.
//

import SwiftUI
import SwiftyChords

struct ChordPicker: View {
    
    @Binding var chord: Chord?
    
    @State private var key: Chords.Key?
    @State private var suffix: Chords.Suffix?
    
    var body: some View {
        HStack {
            Menu {
                ForEach(Chords.Key.allCases, id: \.self) { x in
                    Button(x.rawValue) {
                        self.key = x
                    }
                }
            } label: {
                Text(self.key?.rawValue ?? "Add")
                   
            }
            .labelsHidden()
            Menu {
                ForEach(Chords.Suffix.allCases, id: \.self) { x in
                    Button(x.rawValue) {
                        self.suffix = x
                    }
                }
            } label: {
                Text(self.suffix?.rawValue ?? "Add")
                   
            }
            .labelsHidden()
        }
        .font(.largeTitle)
        .frame(maxWidth: .infinity)
        .onChange(of: suffix) { newValue in
            validate()
        }
        .onChange(of: key) { newValue in
            validate()
        }
        .padding()
    }
    
    private func validate() {
        guard let key = key else {
            return
        }

        guard let suffix = suffix else {
            return
        }
        self.chord = Chord(name: key.rawValue+suffix.rawValue, key: key, suffix: suffix, define: "")
        self.key = nil
        self.suffix = nil
    }
}
