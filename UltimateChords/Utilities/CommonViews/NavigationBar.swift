//
//  NavigationBar.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 19/3/22.
//

import SwiftUI

struct NavigationBar<Content: View>: View {
    
    @Environment(\.presentationMode) private var presentationMode
    private let content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Color(uiColor: .systemBackground)
                .frame(height: 1)
            HStack {
                Button {
                    presentationMode.wrappedValue.dismiss()
                }label: {
                    Image(systemName: "chevron.left")
                }
                
                content()
            }.padding(.horizontal)
        }
    }
}
