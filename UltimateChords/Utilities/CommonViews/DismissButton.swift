//
//  PushBackButton.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 19/3/22.
//

import SwiftUI

struct DismissButton: View {
    
    enum PresentedMode {
        case NavigationStack, Model
    }
    
    @Environment(\.dismiss) private var dismiss
    private let presentedMode: PresentedMode
    
    init(_ presentedMode: PresentedMode) {
        self.presentedMode = presentedMode
    }
    
    var body: some View {
        Button {
            dismiss()
        }label: {
            Group {
                presentedMode == .NavigationStack ? XIcon(.chevron_left) : XIcon(.xmark)
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
            .imageScale(.large)
        }
    }
}
