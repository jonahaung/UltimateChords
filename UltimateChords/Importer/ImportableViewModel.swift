//
//  ImportableViewModel.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 11/4/22.
//

import Foundation
import UIKit

class ImportableViewModel: ObservableObject {
    @Published var importMode: ImageImporter.Mode?
    @Published var importingImage: UIImage?
}
