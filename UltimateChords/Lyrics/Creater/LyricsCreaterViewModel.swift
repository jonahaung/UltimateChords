//
//  LyricsCreaterViewModel.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 22/3/22.
//

import UIKit
import SwiftyChords

final class LyricsCreaterViewModel: NSObject, ObservableObject {
    
    @Published var lyric = Lyric(title: "ခွင့်မပြု", artist: "ထူးအိမ်သင်", text: "")
    @Published var isEditable = true

    
    var didCompleteChordBlk: ((Chord) -> Void)?
    var didUpdateTextBlk: ((String) -> Void)?

    
    func save() {
        _ = CLyric(title: lyric.title, artist: lyric.artist, text: lyric.text)
    }
    
    func fillDemoData() {
        let text = withChords
        lyric.title = text.words().randomElement() ?? ""
        lyric.artist = text.words().randomElement() ?? ""
        lyric.text = text
        
        didUpdateTextBlk?(text)
    }
    
    func didImportText(text: String) {
        lyric.text = text
        didUpdateTextBlk?(text)
    }
}

extension LyricsCreaterViewModel: EditableTextViewDelegate {
    
    func textView(textView: EditableTextView, didTap add: Bool) {
        
    }
}
extension LyricsCreaterViewModel: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        lyric.text = textView.text
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.text = ChordProConverter.convert(textView.text)
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
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
 တရားမျှတ [G]လွတ်လပ်ခြင်းနဲ့မသွေ၊[Am]
 တို့ပြည်၊ [Am]တို့မြေ၊
  [G]များလူခပ်သိမ်း၊ [Am]ငြိမ်းချမ်းစေဖို့၊[Am]
  [F]ခွင့်တူညီမျှ၊ [C]ဝါဒဖြူစင်တဲ့ပြည်၊[Am]
  [Am]တို့ပြည်၊ တို့မြေ၊
  [Am]ပြည်ထောင်စုအမွေ၊ အမြဲတည်တံ့စေ၊
 အဓိဋ္ဌာန်ပြုပေ၊ [Am]ထိန်းသိမ်းစို့လေ[Am][Am]
  [Am]နေကောင်းလားဆရာ
  [Am][Am]ကမ္ဘာမကျေ၊ မြန်မာပြည်၊[Am]
 တို့ဘိုးဘွား [Am][Am]အမွေစစ်မို့ [Am]ချစ်မြတ်နိုးပေ။[Am]
 ပြည်ထောင်စုကို [Am]အသက်ပေးလို့ တို့ကာကွယ်မလေ၊[Am]
  [Am]ဒါတို့ပြည် [Am]ဒါတို့မြေ [Am]တို့ပိုင်နက်မြေ။[Am]
  [Am]တို့ပြည် [Am]တို့မြေ [Am]အကျိုးကို ညီညာစွာတို့တစ်တွေ[Am]
  [Am]ထမ်းဆောင်ပါစို့လေ တို့တာဝန်ပေ အဖိုးတန်မြေ။[Am]
 [Am][Am][Am]

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
let hotelCalifornia = """
[Verse 1]
Am                        E7
On a dark desert highway, cool wind in my hair
G                     D
Warm smell of colitas rising up through the air
F                         C
Up ahead in the distance, I saw a shimmering light
Dm
My head grew heavy and my sight grew dim,
E
I had to stop for the night
 
[Verse 2]
Am                              E7
There she stood in the doorway, I heard the mission bell
G
And I was thinking to myself
              D
This could be heaven or this could be hell
F                         C
Then she lit up a candle, and she showed me the way
Dm
There were voices down the corridor,
E7
I thought I heard them say...
 
[Chorus]
F                         C
 Welcome to the Hotel California
       E7                                         Am
Such a lovely place (such a lovely place), such a lovely face
F                                       C
There's plenty of room at the Hotel California
    Dm                                       E7
Any time of year, (any time of year) You can find it here...
 
[Verse 3]
Am                           E7
Her mind is Tiffany twisted, She got the Mercedes bends
G                                   D
She got a lot of pretty pretty boys that she calls friends
F                                 C
How they danced in the courtyard, sweet summer sweat
Dm                      E7
Some dance to remember, some dance to forget
 
[Verse 4]
Am                           E7
So I called up the captain; "Please bring me my wine" (he said)
G                                     D
"We haven't had that spirit here since 1969"
F                                       C
And still those voices are calling from far away
Dm
Wake you up in the middle of the night
E7
Just to hear them say...
 
[Chorus]
F                         C
 Welcome to the Hotel California
       E7                                         Am
Such a lovely place (such a lovely place), such a lovely face
        F                             C
They're livin' it up at the Hotel California
       Dm                                               E7
What a nice surprise (what a nice surprise), bring your alibis
 
[Verse 5]
Am                      E7
Mirrors on the ceiling, the pink champagne on ice (and she said)
G                               D
We are all just prisoners here, of our own device
F                             C
And in the master's chambers, they gathered for the feast
Dm
They stab it with their steely knives, but they
E7
Just can't kill the beast
 
[Verse 6]
Am                           E7
Last thing I remember, I was running for the door
G                                     D
I had to find the passage back to the place I was before
F                                   C
"Relax" said the night man, "we are programmed to receive,
Dm
You can check out any time you like
E7
But you can never leave"
 
[Outro]
Am E7 G D7 F C Dm E7  x5


"""
