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
    
    @Published var attributedText = NSAttributedString()
    
    @Published var isDinamicFontSizeEnabled = UserDefault.isDinamicFontSizeEnabled {
        didSet {
            guard oldValue != isDinamicFontSizeEnabled else { return }
            UserDefault.isDinamicFontSizeEnabled = isDinamicFontSizeEnabled
        }
    }
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        //        service.$song.sink { [weak self] song in
        //            guard let song = song else { return }
        //            self?.song = song
        //        }
        //        .store(in: &self.subscriptions)
        
        service.$attributedText.sink { [weak self] x in
            guard let x = x else { return }
            self?.attributedText = x
        }
        .store(in: &self.subscriptions)
    }
    
}

extension LyricsViewerViewModel {
    
    func configure(_ lyric: Lyric) async {
        await service.configure(lyric: lyric)
    }
    
    func setDisplayMode(_ newValue: LyricViewerService.DisplayMode) {
        service.setDisplayMode(newValue)
    }
    
    func getSong() -> Song? {
        service.song
    }
    
}

extension LyricsViewerViewModel: WidthFittingTextViewDelegate {
    
    func textView(textView: WidthFittingTextView, didAdjustFontSize text: NSAttributedString) {
        
    }
}
