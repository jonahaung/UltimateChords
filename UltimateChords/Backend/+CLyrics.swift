//
//  +CLyrics.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 22/3/22.
//

import CoreData

extension CLyrics {
    
    class func all() -> [CLyrics] {
        let context = Persistence.shared.context
        let request = NSFetchRequest<CLyrics>(entityName: CLyrics.entity().name!)
        do {
            return try context.fetch(request)
        } catch {
            fatalError()
        }
    }
    
    class func create(lyrics: Lyrics) -> CLyrics {
        let context = Persistence.shared.context
        let x = CLyrics(context: context)
        x.id = UUID().uuidString
        x.artist = lyrics.artist
        x.title = lyrics.title
        x.text = lyrics.text
        Persistence.shared.save()
        return x
    }
    
    class func cLyrics(for id: String) -> CLyrics? {
        let context = Persistence.shared.context
        let request = NSFetchRequest<CLyrics>(entityName: CLyrics.entity().name!)
        request.fetchLimit = 1
        do {
            return try context.fetch(request).first
        } catch {
            fatalError()
        }
    }
}
