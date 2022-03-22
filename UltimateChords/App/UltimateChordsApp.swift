//
//  UltimateChordsApp.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 15/3/22.
//

import SwiftUI

@main
struct UltimateChordsApp: App {

    var body: some Scene {
        WindowGroup {
            MainNavigationView()
                .onAppear{
                    Persistence.shared
                }
        }
    }
}
