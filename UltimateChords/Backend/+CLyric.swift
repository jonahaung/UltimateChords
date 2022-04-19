//
//  +CLyrics.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 22/3/22.
//

import CoreData

extension CLyric {
    
    
    convenience init(title: String, artist: String, text: String, version: Int16) {
        let context = Persistence.shared.context
        self.init(context: context)
        self.id = UUID().uuidString
        self.title = title
        self.artist = artist
        self.text = text
        self.date = Date()
        self.lastViewed = Date()
        self.version = version
        Persistence.shared.save()
    }
    
    func updateLastView() {
        lastViewed = Date()
    }
    
    var versionTitle: String {
        return title.str + (version > 0 ? " \(version)" : "")
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
    
    class func create(lyric: Lyric) -> CLyric {
        let sameItems = sameItems(title: lyric.title, artist: lyric.artist)
        let sorted = sameItems.sorted { one, two in
            one.version > two.version
        }
        return CLyric(title: lyric.title, artist: lyric.artist, text: lyric.text, version: (sorted.first?.version ?? -1) + 1 )
    }
    
    class func sameItems(title: String, artist: String) -> [CLyric] {
        let context = Persistence.shared.context
        let request = NSFetchRequest<CLyric>(entityName: CLyric.entity().name!)
        let title = NSPredicate(format: "title == %@", title)
        let artist = NSPredicate(format: "artist == %@", artist)
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [title, artist])
        do {
            return try context.fetch(request)
        } catch {
            fatalError()
        }
    }
    class func cLyrics(for id: String) -> CLyric? {
        let context = Persistence.shared.context
        let request = NSFetchRequest<CLyric>(entityName: CLyric.entity().name!)
        request.predicate = NSPredicate(format: "id == %@", id)
        request.sortDescriptors = [NSSortDescriptor(key: "lastViewed", ascending: false)]
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
