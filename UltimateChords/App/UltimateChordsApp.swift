//
//  UltimateChordsApp.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 15/3/22.
//

import SwiftUI

@main
struct UltimateChordsApp: App {
    
    let persistance = Persistence.shared
    
    var body: some Scene {
        WindowGroup {
            MainNavigationView().environment(\.managedObjectContext, persistance.container.viewContext)
        }
    }
}
