//
//  LyricCreaterForm.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 13/4/22.
//

import SwiftUI

struct LyricCreaterForm: View {
    
    @StateObject private var viewModel = LyricCreaterFormViewModel()
    var body: some View {
        Form {
            Section {
                TextField("Title", text: $viewModel.title)
                TextField("Artist", text: $viewModel.artist)
            }
        }
    }
}
