//
//  LyricsCreaterViewModel.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 22/3/22.
//

import UIKit
import SwiftyChords

final class LyricsCreaterViewModel: NSObject, ObservableObject {
    @Published var importMode: ImageImporter.Mode?
    @Published var tempSong = CreateLyrics(title: "", artist: "", text: "")
    @Published var isEditable = true
    @Published var isChordMode = false
    @Published var showChordPicker = false
    @Published var chord: Chord? {
        didSet {
            guard oldValue != chord else { return }
            if let chord = chord {
                didAddChord(chord: chord)
            }
        }
    }
    
    var didCompleteChordBlk: ((Chord) -> Void)?
    var didUpdateTextBlk: ((String) -> Void)?

    
    func save() {
        _ = Lyric(title: tempSong.title, artist: tempSong.artist, text: tempSong.text)
    }
    
    func fillDemoData() {
        let text = withoutChords
        tempSong.title = text.words().randomElement() ?? ""
        tempSong.artist = text.words().randomElement() ?? ""
        tempSong.text = text
        didUpdateTextBlk?(text)
    }
    func didAddChord(chord: Chord) {
        self.chord = nil
        didCompleteChordBlk?(chord)
    }
    
    func didImportText(text: String) {
        tempSong.text.append(text.newLine)
        didUpdateTextBlk?(tempSong.text)
    }
}

extension LyricsCreaterViewModel: EditableTextViewDelegate {
    
    func textView(textView: EditableTextView, didTap add: Bool) {
        self.showChordPicker = add
    }
}
extension LyricsCreaterViewModel: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        tempSong.text = textView.text
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        guard isChordMode else { return true }
        
        func pre() -> String {
           
            let xRange = NSRange(location: range.location - 1, length: 1)
            return (textView.text as NSString).substring(with: xRange)
        }
        
        func next() -> String {
            let xRange = NSRange(location: range.location + 1, length: 1)
            return (textView.text as NSString).substring(with: xRange)
        }
        
        if range.length > 0 {
            let new = NSRange(location: range.location, length: 1)
            let deleted = (textView.text as NSString).substring(with: new)
            if deleted == "[" {
                textView.selectedRange.location += 1
                textView.deleteBackward()
            }
            return true
        }
        
        if text == " " {
            if pre() == "[" || next() == "]" {
                return false
            } else {
                textView.insertText("[]")
                textView.selectedRange.location -= 1
            }
            return false
        }
        
        var words = ["", " ", "\n"]
    
        Chords.Key.allCases.map{ $0.rawValue }.forEach { key in
            Chords.Suffix.allCases.map{ $0.rawValue }.forEach { suff in
                let x = key + suff
                words.append(x)
            }
        }
        
        return words.contains { str in
            str.contains(text)
        }
    }
}

let withoutChords = """
 တရားမျှတ လွတ်လပ်ခြင်းနဲ့မသွေ၊
 တို့ပြည်၊ တို့မြေ၊
 များလူခပ်သိမ်း၊ ငြိမ်းချမ်းစေဖို့၊
 ခွင့်တူညီမျှ၊ ဝါဒဖြူစင်တဲ့ပြည်၊
 တို့ပြည်၊ တို့မြေ၊
 ပြည်ထောင်စုအမွေ၊ အမြဲတည်တံ့စေ၊
 အဓိဋ္ဌာန်ပြုပေ၊ ထိန်းသိမ်းစို့လေ
 နေကောင်းလားဆရာ @am
 ကမ္ဘာမကျေ၊ မြန်မာပြည်၊
 တို့ဘိုးဘွား အမွေစစ်မို့ ချစ်မြတ်နိုးပေ။
 ပြည်ထောင်စုကို အသက်ပေးလို့ တို့ကာကွယ်မလေ၊
 ဒါတို့ပြည် ဒါတို့မြေ တို့ပိုင်နက်မြေ။
 တို့ပြည် တို့မြေ အကျိုးကို ညီညာစွာတို့တစ်တွေ
 ထမ်းဆောင်ပါစို့လေ တို့တာဝန်ပေ အဖိုးတန်မြေ။


 တရားမျှတ လွတ်လပ်ခြင်းနဲ့မသွေ၊
 တို့ပြည်၊ တို့မြေ၊
 များလူခပ်သိမ်း၊ ငြိမ်းချမ်းစေဖို့၊
 ခွင့်တူညီမျှ၊ ဝါဒဖြူစင်တဲ့ပြည်၊
 တို့ပြည်၊ တို့မြေ၊
 ပြည်ထောင်စုအမွေ၊ အမြဲတည်တံ့စေ၊
 အဓိဋ္ဌာန်ပြုပေ၊ ထိန်းသိမ်းစို့လေ

 ကမ္ဘာမကျေ၊ မြန်မာပြည်၊
 တို့ဘိုးဘွား အမွေစစ်မို့ ချစ်မြတ်နိုးပေ။
 ပြည်ထောင်စုကို အသက်ပေးလို့ တို့ကာကွယ်မလေ၊
 ဒါတို့ပြည် ဒါတို့မြေ တို့ပိုင်နက်မြေ။
 တို့ပြည် တို့မြေ အကျိုးကို ညီညာစွာတို့တစ်တွေ
 ထမ်းဆောင်ပါစို့လေ တို့တာဝန်ပေ အဖိုးတန်မြေ။
 """
 let withChords = """
[C][Am][F][G]
[C]တရားမျှတ [Am]လွတ်လပ်ခြင်းနဲ့မသွေ၊
တို့ပြည်၊ [F]တို့မြေ၊[G]
[C]များလူခပ်သိမ်း၊ [Am]ငြိမ်းချမ်းစေဖို့၊[G]
ခွင့်တူညီမျှ၊ [F]ဝါဒဖြူစင်တဲ့ပြည်၊[F][G]
တို့ပြည်၊ [C]တို့မြေ၊
ပြည်[Am]ထောင်စုအမွေ၊ [G]အမြဲတည်တံ့စေ၊[F][Am]
[C]အဓိဋ္ဌာန်ပြုပေ၊ [G]ထိန်း[F]သိမ်းစို့လေ[Am]

ကမ္ဘာမကျေ၊[G] မြန်မာပြည်၊[Am][C][G]
[Am]တို့ဘိုးဘွား [C]အမွေစစ်မို့ [G]ချစ်မြတ်နိုးပေ။
ပြည်ထောင်စုကို [Dm]အသက်ပေးလို့ [Am]တို့ကာကွယ်မလေ၊[C][F][G]
ဒါတို့ပြည် [An]ဒါတို့မြေ [C]တို့ပိုင်နက်မြေ။[F]
[C]တို့ပြည် တို့မြေ [F]အကျိုးကို [G]ညီညာစွာတို့တစ်တွေ[Am]
[F]ထမ်းဆောင်ပါစို့လေ [G]တို့တာဝန်ပေ အဖိုးတန်မြေ။[C]

[C][Am][F][G]
[C]တရားမျှတ [Am]လွတ်လပ်ခြင်းနဲ့မသွေ၊
တို့ပြည်၊ [F]တို့မြေ၊[G]
[C]များလူခပ်သိမ်း၊ [Am]ငြိမ်းချမ်းစေဖို့၊[G]
ခွင့်တူညီမျှ၊ [F]ဝါဒဖြူစင်တဲ့ပြည်၊[F][G]
တို့ပြည်၊ [C]တို့မြေ၊
ပြည်[Am]ထောင်စုအမွေ၊ [G]အမြဲတည်တံ့စေ၊[F][Am]
[C]အဓိဋ္ဌာန်ပြုပေ၊ [G]ထိန်း[F]သိမ်းစို့လေ[Am]

ကမ္ဘာမကျေ၊[G] မြန်မာပြည်၊[Am][C][G]
[Am]တို့ဘိုးဘွား [C]အမွေစစ်မို့ [G]ချစ်မြတ်နိုးပေ။
ပြည်ထောင်စုကို [Dm]အသက်ပေးလို့ [Am]တို့ကာကွယ်မလေ၊[C][F][G]
ဒါတို့ပြည် [An]ဒါတို့မြေ [C]တို့ပိုင်နက်မြေ။[F]
[C]တို့ပြည် တို့မြေ [F]အကျိုးကို [G]ညီညာစွာတို့တစ်တွေ[Am]
[F]ထမ်းဆောင်ပါစို့လေ [G]တို့တာဝန်ပေ အဖိုးတန်မြေ။[C]


"""
