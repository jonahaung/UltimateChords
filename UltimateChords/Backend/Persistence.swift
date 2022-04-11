//
//  Persistence.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 15/3/22.
//

import CoreData

class Persistence {
    
    static let shared = Persistence()
    class func setup() {
        _ = shared
    }
    
    let container: NSPersistentCloudKitContainer
    
    var context: NSManagedObjectContext { container.viewContext }
    
    private init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "UltimateChords")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    func save() {
        let context = self.context
        if context.hasChanges {
            do {
                try context.save()
            }catch {
                print(error.localizedDescription)
            }
        }
    }
}
