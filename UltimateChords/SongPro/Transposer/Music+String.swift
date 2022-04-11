//
//  +String.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 10/4/22.
//

import Foundation

extension MusicText {
    static func musicalComponents(from string: String) -> [String] {
        var components = [String]()
        let start = string.startIndex
        var currentComponent = ""
        var i = 0
        repeat {
            let index = string.index(start, offsetBy: i)
            var char = String(string[index])
            
            if Music.allNotes.contains(char) {
                // Save the previous characters and reset currentComponent
                components.append(currentComponent)
                currentComponent = ""
                
                // If this isn't last character, check the next character to see if it's part of the note name.
                if index != string.index(before: string.endIndex) {
                    let nextIndex = string.index(index, offsetBy: 1)
                    let nextChar = string[nextIndex]
                    if Music.accidentalSymbols.keys.contains(nextChar) {
                        char += String(nextChar)
                        i += 1
                    }
                }
                components.append(char)
            } else {
                currentComponent += char
            }
            i += 1
        } while i < string.count
        
        components.append(currentComponent)
        return components
    }
}

extension String {
    
    func transpose(from sourceKey: MusicKey, to destKey: MusicKey) -> String {
        
        let newString = self
        var newComponents = MusicLine()
        
        for component in newString.split(separator: " ").map({String($0)}) {
            if component.looksLikeMusic {
                var newSubComponent = ""
                for subcomponent in MusicText.musicalComponents(from: component) {
                    if let transposedNote = MusicNote(subcomponent)?.transpose(from: sourceKey, to: destKey) {
                        newSubComponent += transposedNote.name
                    }  else {
                        newSubComponent += subcomponent
                    }
                }
                newComponents.append(newSubComponent)
            } else {
                newComponents.append(component)
            }
        }
        
        return newComponents.joined(separator: " ")
    }
    
    func transpose(fromString sourceKey: String, toString destKey: String) -> String? {
        guard let source = MusicKey(sourceKey), let dest = MusicKey(destKey) else { return nil }
        return self.transpose(from: source, to: dest)
    }
    
}
