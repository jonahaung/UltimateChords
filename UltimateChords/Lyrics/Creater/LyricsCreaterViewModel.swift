//
//  LyricsCreaterViewModel.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 22/3/22.
//

import UIKit

class LyricImporterViewModel: NSObject, ObservableObject {
    
    @Published var importMode: Mode?
    private var previousImportMode: Mode?
    @Published var pickedImage: UIImage?
    var pickedItem: PickedItem?
    var ocrResult: OcrImageView.ResultType?
    
    func setImportMode(mode: Mode?) {
        importMode = mode
        previousImportMode = mode
    }
    func redoImportMode() {
        setImportMode(mode: previousImportMode)
    }
}

extension LyricImporterViewModel {
    enum Mode: String, CustomStringConvertible, CaseIterable, Identifiable {
        case Document_Scanner, Camera, Photo_Library, ChordPro_File
        var id: String { rawValue }
        var description: String {
            rawValue.replacingOccurrences(of: "_", with: " ")
        }
    }
}


final class LyricsCreaterViewModel: LyricImporterViewModel {
    
    @Published var lyric = Lyric.empty
    weak var textView: EditableTextView?
    @Published var isSaved = false
    
    var isEditable: Bool {
        get { textView?.isEditable == true }
        set { textView?.isEditable = newValue }
    }
    
    func save() {
        lyric.text = textView?.text ?? ""
        _ = CLyric.create(lyric: lyric)
        self.isSaved = true
    }
    
    func insertText(_ string: String) {
        let song = SongConverter.parse(rawText: string)
        lyric.text = song.rawText
        if let title = song.title {
            lyric.title = title
        }
        if let artist = song.artist {
            lyric.artist = artist
        }
        if let key = song.key {
            lyric.key = key
        }
        textView?.insert(text: song.rawText)
    }
    
    deinit {
        print("LyricsCreaterViewModel")
    }
}


extension LyricsCreaterViewModel: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        lyric.text = textView.text
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
