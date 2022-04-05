//
//  TapToShowComfirmationDialog.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 5/4/22.
//

import SwiftUI

struct TapToShowComfirmationDialogStyle<CContent: View>: ViewModifier {
    
    @State private var show = false
    
    private let cContent: () -> CContent
    
    init(@ViewBuilder content: @escaping () -> CContent) {
        self.cContent = content
    }
    
    func body(content: Content) -> some View {
        Button {
            show = true
        } label: {
            content
        }
        .confirmationDialog("", isPresented: $show, titleVisibility: .hidden) {
            cContent()
        }
    }
}

extension View {
    func tapToShowComfirmationDialog<CContent: View>(@ViewBuilder content: @escaping () -> CContent) -> some View {
        ModifiedContent(content: self, modifier: TapToShowComfirmationDialogStyle(content: content))
    }
}
