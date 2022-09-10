//
//  CoreDataStack.swift
//  ParkInBordeaux
//
//  Created by Clément Garcia on 09/09/2022.
//

import Foundation
import CoreData

open class CoreDataStack {
    
    // MARK: - Properties
    /// Allow to set the model that must used by the CoreDataStack
    private let modelName: String
    /// Provide the main context using an "easy" way
    public lazy var mainContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    // MARK: - Initializer
    public init(modelName: String) {
        self.modelName = modelName
    }
    
    // MARK: - Core Data stack
    public lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Functions
    /// Save current context for the CoreDataStack
    func saveContext() -> CarParksServiceError? {
        guard mainContext.hasChanges else { return .localDataCorrupt }
        do {
            try mainContext.save()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
            return .localDataCorrupt
        }
        return nil
    }
}
