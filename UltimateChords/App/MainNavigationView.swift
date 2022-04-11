//
//  MainNavigationView.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 22/3/22.
//

import SwiftUI

struct MainNavigationView: View {
    var body: some View {
        NavigationView {
            HomeView()
        }
        .navigationViewStyle(.stack)
    }
}
