//
//  CoreDataStack.swift
//  NewsFeed
//
//  Created by MacMini 20 on 8/27/20.
//  Copyright © 2020 MacMini 20. All rights reserved.
//

import CoreData

class CoreDataStack {
    
    private init() {}
    static let shared = CoreDataStack()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NewsDataModel")
        
        container.loadPersistentStores(completionHandler: { (_, error) in
            guard let error = error as NSError? else { return }
            fatalError("Unresolved error: \(error), \(error.userInfo)")
        })
        
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.undoManager = nil
        container.viewContext.shouldDeleteInaccessibleFaults = true
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        return container
    }()
    
    lazy var managedContext = persistentContainer.viewContext
    lazy var fetchRequestForKeyword = NSFetchRequest<NSManagedObject>(entityName: "SearchKeyword")
    lazy var searchKeywordEntity = NSEntityDescription.entity(forEntityName: "SearchKeyword", in: managedContext)!
    
    lazy var keywordObject = NSManagedObject(entity: searchKeywordEntity, insertInto: managedContext)
    func isKeywordAlreadySearched(keywordToSearch: String) -> Bool {
        var isPresent = false
        do {
            let keywords = try managedContext.fetch(fetchRequestForKeyword)
            let foundResult = keywords.filter{ keyword in
                (keyword.value(forKey: "keyword") as? String)?.uppercased() == keywordToSearch.uppercased()
            }
            isPresent = foundResult.count > 0
        } catch {
            isPresent = false
        }
        return isPresent
    }
    
    func addSearchTextToDB(search: String) {
        keywordObject.setValue(search, forKey: "keyword")
        do {
          try managedContext.save()
        } catch let error as NSError {
          print("Fetch: Could not save. \(error), \(error.userInfo)")
        }
    }
}
