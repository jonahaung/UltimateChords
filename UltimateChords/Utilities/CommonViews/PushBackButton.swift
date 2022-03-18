//
//  PushBackButton.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 19/3/22.
//

import SwiftUI

struct PushBackButton: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Button {
            dismiss()
        }label: {
            Image(systemName: "chevron.left")
        }
    }
}
