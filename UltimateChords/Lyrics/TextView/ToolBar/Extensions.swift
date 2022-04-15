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
    
    func insertMarkedText() {
        if let range = self.markedTextRange, let markedText = self.text(in: range)?.localisedSuffix {
            self.insertText(markedText)
        }
    }
    func insertSpace() {
        if markedTextRange != nil {
            insertMarkedText()
            return
        }
        insertText(" ")
    }
    func removeMarkedText() {
        setMarkedText(nil, selectedRange: selectedRange)
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
