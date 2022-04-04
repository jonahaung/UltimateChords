//
//  +CLyrics.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 22/3/22.
//

import CoreData

extension Lyric {
    
    func song() -> Song {
        var song = ChordPro.parse(rawText: text!)
        if song.title == nil {
            song.title = self.title
        }
        if song.artist == nil {
            song.artist = self.artist
        }
        return song
    }
    var title: String {
        get {
            rawTitle?.urlDecoded ?? ""
        }
    }
    
    var artist: String {
        get {
            rawArtist?.urlDecoded ?? ""
        }
    }
    
    convenience init(title: String, artist: String, text: String) {
        let context = Persistence.shared.context
        self.init(context: context)
        self.id = UUID().uuidString
        self.rawTitle = title.urlEncoded
        self.rawArtist = artist.urlEncoded
        self.text = text
        self.date = Date()
        self.lastViewed = Date()
        Persistence.shared.save()
    }
    
    func updateLastView() {
        lastViewed = Date()
    }
}

extension Lyric {
    
    class func all() -> [Lyric] {
        let context = Persistence.shared.context
        let request = NSFetchRequest<Lyric>(entityName: Lyric.entity().name!)
        do {
            return try context.fetch(request)
        } catch {
            fatalError()
        }
    }
    
    class func create(song: Song) -> Lyric {
        return Lyric(title: song.title ?? "", artist: song.artist ?? "", text: song.rawText)
    }
    
    class func cLyrics(for id: String) -> Lyric? {
        let context = Persistence.shared.context
        let request = NSFetchRequest<Lyric>(entityName: Lyric.entity().name!)
        request.fetchLimit = 1
        do {
            return try context.fetch(request).first
        } catch {
            fatalError()
        }
    }
    
    class func delete(cLyrics: Lyric) {
        let context = Persistence.shared.context
        context.delete(cLyrics)
    }
    
    class func search(text: String) -> [Lyric] {
        let context = Persistence.shared.context
        let request = NSFetchRequest<Lyric>(entityName: Lyric.entity().name!)
        let title = NSPredicate(format: "rawTitle CONTAINS[cd] %@", text.urlEncoded)
        let artist = NSPredicate(format: "rawArtist CONTAINS[cd] %@", text.urlEncoded)
        request.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [title, artist])
        do {
            return try context.fetch(request)
        } catch {
            fatalError()
        }
    }
}
