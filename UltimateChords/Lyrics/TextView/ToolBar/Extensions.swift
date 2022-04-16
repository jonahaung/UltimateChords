//
//  Extensions.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 15/4/22.
//

import Foundation
import SwiftyChords
import UIKit

extension String {
    
    var bracked: String {
        "[\(self)]"
    }
    
    var localisedSuffix: String {
        if self == "major" {
            return String()
        } else if self == "minor" {
            return "m"
        }
        return self
    }
}

extension UITextView {

    
    func insertSpace() {
        if markedTextRange != nil {
            unmarkText()
            return
        }
        insertText(" ")
    }
    
    func setMarkedText(_ string: String?) {
        setMarkedText(string, selectedRange: selectedRange)
    }
    func removeMarkedText() {
        setMarkedText(nil)
    }
    func undo() {
        if undoManager?.canRedo == true {
            undoManager?.undo()
        }
    }
    func redo() {
        if undoManager?.canRedo == true {
            undoManager?.redo()
        }
    }
}

extension UICollectionView {
    func deselectAll() {
        indexPathsForSelectedItems?.forEach {
            deselectItem(at: $0, animated: true)
        }
    }
}
