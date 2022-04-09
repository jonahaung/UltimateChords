//
//  NavBar.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 9/4/22.
//

import SwiftUI

struct NavBar<Content: View>: View {
    
    private let content: () -> Content
    @Environment(\.dismiss) private var dismiss
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                XIcon(.chevron_left)
                    .padding()
            }
            content()
        }
        
    }
}
