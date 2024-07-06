//
//  CoreDataStack.swift
//  NewsApp
//
//  Created by rendi on 06.07.2024.
//

import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()

    private init() {}

    lazy var context: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NewsApp")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

