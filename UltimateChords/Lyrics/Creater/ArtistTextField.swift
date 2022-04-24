//
//  ArtistUITextField.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 24/4/22.
//

import SwiftUI

struct ArtistTextField: UIViewRepresentable {
    
    @Binding var text: String
    
    func makeUIView(context: Context) -> AutoCompleteTextField {
        let textField = AutoCompleteTextField(frame: .zero, dataSource: context.coordinator, delegate: context.coordinator)
        textField.placeholder = "Singer / Artist"
        textField.ignoreCase = false
        return textField
    }
    
    func updateUIView(_ uiView: AutoCompleteTextField, context: Context) {
        if uiView.isFirstResponder == false {
            uiView.text = text
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    
}

extension ArtistTextField {
    
    class Coordinator: NSObject, ACTFDataSource, UITextFieldDelegate {
        
        var weightedDomains: [AutoCompleteData] = []
        
        override init() {
            weightedDomains = Singers.allSingers.map{ AutoCompleteData(text: $0, weight: 0)}
            
        }
        func autoCompleteTextFieldDataSource(_ autoCompleteTextField: AutoCompleteTextField) -> [AutoCompleteData] {
            weightedDomains
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if string == " " {
                (textField as? AutoCompleteTextField)?.commitAutocompleteText()
            }
            return true
        }
    }
}
