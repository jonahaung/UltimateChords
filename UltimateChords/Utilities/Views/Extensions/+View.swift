//
//  +View.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 17/3/22.
//

import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

}
