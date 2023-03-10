//
//  PersistenceController.swift
//  SanchesRun
//
//  Created by tae hoon park on 2023/03/06.
//

import CoreData

struct PersistenceController {
  static let shared = PersistenceController()
  let container: NSPersistentCloudKitContainer
  var viewContext: NSManagedObjectContext {
    container.viewContext
  }
  
  private init() {
    container = NSPersistentCloudKitContainer(name: "SanchesRun")
    guard let description = container.persistentStoreDescriptions.first else {
      fatalError("Failed to initialize persistent container")
    }
    description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
    container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    container.viewContext.automaticallyMergesChangesFromParent = true
    container.loadPersistentStores { storeDescription, error in
      if let nserror = error as NSError? {
        fatalError("Unresolved error: \(nserror), \(nserror.userInfo)")
      }
    }
  }
  
  func save() {
    do {
      try viewContext.save()
    } catch {
      let nserror = error as NSError
      fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
    }
  }
}
