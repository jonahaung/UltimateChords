//
//  TextVeiwWrapper.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 16/3/22.
//

import SwiftUI

struct DPTagTextViewWrapper: UIViewRepresentable {

    @EnvironmentObject var tagsControl: LyricsEditorManager
    
    func makeUIView(context: Context) -> DPTagTextView {
        let view = DPTagTextView()

        view.isEditable = context.coordinator.isEditable
        view.isSelectable = context.coordinator.isSelectable
        view.isDetectable = context.coordinator.isDetectable
        view.dpTagDelegate = context.coordinator
        context.coordinator.setLyricsDataBlock = { [weak view] x in
            view?.setLyricsData(x)
        }
        context.coordinator.addTagBlock = { [weak view] x in
            view?.addTag(tagText: x)
        }
        return view
    }
    
    func updateUIView(_ uiView: DPTagTextView, context: Context) {
        uiView.isEditable = context.coordinator.isEditable
        uiView.isSelectable = context.coordinator.isSelectable
        uiView.isDetectable = context.coordinator.isDetectable
    }
    
    func makeCoordinator() -> LyricsEditorManager {
        return tagsControl
    }
}
