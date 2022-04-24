//
//  ACTFWeightedDomain.swift
//  Pods
//
//  Created by Neil Francis Hipona on 9/15/17.
//  Copyright © 2017 AJ Bartocci. All rights reserved.
//

import Foundation

public struct AutoCompleteData: Codable {
    
    public let text: String
    public var weight: Int
    
    // MARK: - Initializer
    
    public init(text t: String, weight w: Int) {
        
        text = t
        weight = w
    }
    
    // MARK: - Functions
    
    public mutating func updateWeightUsage() {
        
        weight += 1
    }
}
