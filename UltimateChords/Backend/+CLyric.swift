//
//  +CLyrics.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 22/3/22.
//

import CoreData

extension CLyric {
    
    func song() -> Song {
        var song = SongConverter.parse(rawText: text!)
        if song.title == nil {
            song.title = self.title
        }
        if song.artist == nil {
            song.artist = self.artist
        }
        return song
    }
    
    convenience init(title: String, artist: String, text: String) {
        let context = Persistence.shared.context
        self.init(context: context)
        self.id = UUID().uuidString
        self.title = title
        self.artist = artist
        self.text = text
        self.date = Date()
        self.lastViewed = Date()
        Persistence.shared.save()
    }
    
    func updateLastView() {
        lastViewed = Date()
    }
}

extension CLyric {
    
    class func all() -> [CLyric] {
        let context = Persistence.shared.context
        let request = NSFetchRequest<CLyric>(entityName: CLyric.entity().name!)
        request.sortDescriptors = [NSSortDescriptor(key: "lastViewed", ascending: false)]
        do {
            return try context.fetch(request)
        } catch {
            fatalError()
        }
    }
    
    class func create(song: Song) -> CLyric {
        return CLyric(title: song.title.str, artist: song.artist.str, text: song.rawText)
    }
    
    class func cLyrics(for id: String) -> CLyric? {
        let context = Persistence.shared.context
        let request = NSFetchRequest<CLyric>(entityName: CLyric.entity().name!)
        request.fetchLimit = 1
        do {
            return try context.fetch(request).first
        } catch {
            fatalError()
        }
    }
    
    class func delete(cLyrics: CLyric) {
        let context = Persistence.shared.context
        context.delete(cLyrics)
    }
    
    class func search(text: String) -> [CLyric] {
        let context = Persistence.shared.context
        let request = NSFetchRequest<CLyric>(entityName: CLyric.entity().name!)
        let title = NSPredicate(format: "title CONTAINS[cd] %@", text)
        let artist = NSPredicate(format: "artist CONTAINS[cd] %@", text)
        request.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [title, artist])
        request.sortDescriptors = [NSSortDescriptor(key: "lastViewed", ascending: false)]
        do {
            return try context.fetch(request)
        } catch {
            fatalError()
        }
    }
}
