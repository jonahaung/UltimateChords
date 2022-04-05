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
    @Published var displayMode = LyricViewerService.DisplayMode.Default
    @Published var showChords = false
    @Published var activityItem: ActivityItem?
    
    @Published var isDinamicFontSizeEnabled = UserDefault.isDinamicFontSizeEnabled {
        didSet {
            guard oldValue != isDinamicFontSizeEnabled else { return }
            UserDefault.isDinamicFontSizeEnabled = isDinamicFontSizeEnabled
        }
    }
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        service.$attributedText.sink { [weak self] x in
            guard let x = x else { return }
            self?.attributedText = x
        }
        .store(in: &self.subscriptions)
        
        service.$displayMode.sink { [weak self] x in
            self?.displayMode = x
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
