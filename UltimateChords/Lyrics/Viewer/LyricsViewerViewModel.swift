//
//  LyricsViewerViewModel.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 18/3/22.
//

import UIKit
import Combine

class LyricsViewerViewModel: ObservableObject {
    
    private let service = LyricViewerService()
    
    
    @Published var song: Song?
    var isDinamicFontSizeEnabled = UserDefault.isDinamicFontSizeEnabled {
        didSet {
            guard oldValue != isDinamicFontSizeEnabled else { return }
            UserDefault.isDinamicFontSizeEnabled = isDinamicFontSizeEnabled
            objectWillChange.send()
        }
    }
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        service.$song.sink { [weak self] song in
            guard let song = song else { return }
            self?.song = song
        }
        .store(in: &self.subscriptions)
    }
    
}

extension LyricsViewerViewModel {
    
    func configure(_ lyric: Lyric) async {
        await service.configure(lyric: lyric)
    }

}

extension LyricsViewerViewModel: WidthFittingTextViewDelegate {
    
    func textView(textView: WidthFittingTextView, didAdjustFontSize text: NSAttributedString) {
        
    }
}
