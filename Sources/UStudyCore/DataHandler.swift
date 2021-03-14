//
//  DataHandler.swift
//  UStudy
//
//  Created by Jann Schafranek on 25.01.19.
//  Copyright © 2019 Jann Thomas. All rights reserved.
//

import Foundation
import CoreData
import SchafKit

public let dataHandler = DataHandler.shared
public let viewContext = DataHandler.shared.viewContext

public class DataHandler {
    public static let shared = DataHandler()
    
    public let viewContext : NSManagedObjectContext
    
    let persistentContainer: NSPersistentContainer = {
        let url = "UStudy"
        _ = OKDirectory.applicationSupport.directoryByAppending(path: url, createIfNonexistant: true)
        
        guard let modelURL = Bundle.module.url(forResource: url, withExtension: "momd") else { fatalError() }
        guard let model = NSManagedObjectModel(contentsOf: modelURL) else { fatalError() }
        let container = CoreContainer(name: "UStudy", managedObjectModel: model)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    init() {
        viewContext = persistentContainer.viewContext
        
        viewContext.automaticallyMergesChangesFromParent = true
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    }
    
    // MARK: - Core Data Saving support
    
    private var scheduledSaveTimer : Timer?
    func scheduleSave() {
        scheduledSaveTimer?.invalidate()
        
        scheduledSaveTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { _ in
            self.save()
        })
    }
    
    func save (context : NSManagedObjectContext? = nil) {
        let context = context ?? viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Retriever Functions
    
    func getObjects<T : NSManagedObject> (ofType type : T.Type) -> [T]? {
        return getObjects(withType: String(describing: type)) as? [T]
    }
    
    private func getObjects (withType type : String) -> [NSManagedObject]? {
        return viewContext.getAllObjects(with: type, predicates: nil, sortDescriptors: nil)
    }
    
    func getObject<T : NSManagedObject> (withType type : T.Type, id : String) -> T? {
        return getObject(withType: String(describing: type), id: id) as? T
    }
    
    private func getObject (withType type : String, id : String) -> NSManagedObject? {
        return viewContext.getAllObjects(with: type, predicates: [NSPredicate(format: "id = %@", id)], sortDescriptors: nil, limit: 1).first
    }
}

// This empty subclass tells CoreData that the Framework bundle should be seached for the data model and not the main bundle.
private class CoreContainer: NSPersistentContainer {}
