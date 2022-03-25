//
//  LyricsCreaterViewModel.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 22/3/22.
//

import UIKit

final class LyricsCreaterViewModel: NSObject, ObservableObject {
    
    var lyrics = Lyrics(title: "Perfect", artist: "Ed Sheron", text: perfect)
    @Published var canInputLyrics = false
    
    override init() {
        lyrics.displayMode = .Editing
    }
    func isValidArtist() -> Bool {
        !lyrics.artist.isEmpty && !lyrics.artist.isEmpty
    }
    
    func save() {
        CLyrics.create(lyrics: self.lyrics)
    }
}

extension LyricsCreaterViewModel: WidthFittingTextViewDelegate {
    
    func textView(_ textView: WidthFittingTextView, didAdjustFontSize fontSize: CGFloat) {
        print(fontSize)
    }
    
    func textViewDidChange(_ textView: WidthFittingTextView) {
        self.lyrics.text = textView.text
    }
}


 let perfect = """
(VERSE)
I found a [G]love for [Em]me
Darling just [C]dive right in, and follow my [D]lead
Well I found a [G]girl beautiful[Em] and sweet
I never [C]knew you were the someone waiting for [D]me

(PRE-CHORUS)
Cause we were just kids when we [G]fell in love
Not knowing [Em]what it was, I will not [C]give you up this [G]ti-[D]ime
But darling just [G]kiss me slow, your heart is [Em]all I own
And in your [C]eyes you’re holding [D]mine

(CHORUS)
Baby, [Em]I’m [C]dancing in the [G]dark, with [D]you between my [Em]arms
[C]Barefoot on the [G]grass, [D]listening to our [Em]favorite song
When you [C]said you looked a [G]mess, I whispered [D]underneath my [Em]breath
But you [C]heard it, darling [G]you look [D]perfect tonight
[G] [D/F#] [Em] [D] [C] - [D]

(VERSE)
Well I found a [G]woman, stronger than [Em]anyone I know
She shares my [C]dreams, I hope that someday I’ll share her [D]home
I found a [G]love, to carry [Em]more than just my secrets
To carry [C]love, to carry children of our [D]own

(PRE-CHORUS)
We are still kids, but we’re [G]so in love, fighting [Em]against all odds
I know that we’ll [C]be alright this [G]ti-[D]ime
Darling just [G]hold my hand, be my girl, I’ll [Em]be your man
I see my [C]future in your [D]eyes

(CHORUS)
Baby, [Em]I’m [C]dancing in the [G]dark, with [D]you between my [Em]arms
[C]Barefoot on the [G]grass, [D]listening to our [Em]favorite song
When I [C]saw you in that [G]dress, looking so [D]beautiful
I [Em]don't [C]deserve this, darling [G]you look [D]perfect tonight

(BRIDGE)
[G] [Em] [C] [D]

(CHORUS)
Baby, [Em]I’m [C]dancing in the [G]dark, with [D]you between my [Em]arms
[C]Barefoot on the [G]grass, [D]listening to our [Em]favorite song
I have [C]faith in what I [G]see, now I know [D]I have met an [Em]angel
In [C]person, and [G]she looks [D]perfect
No I [C]don't deserve it, [D]you look perfect tonight
[G] [D/F#] [Em] [D] [C] - [D] -
"""
