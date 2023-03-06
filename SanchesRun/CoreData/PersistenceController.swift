//
//  PersistenceController.swift
//  SanchesRun
//
//  Created by tae hoon park on 2023/03/06.
//

import CoreData

struct PersistenceController {
  static let shared = PersistenceController()
  let container: NSPersistentContainer
  var viewContext: NSManagedObjectContext {
    container.viewContext
  }
  
  private init() {
    NMGLatLngTransformer.register()
    container = NSPersistentContainer(name: "SanchesRun")
    container.loadPersistentStores { storeDescription, error in
      if let nserror = error as NSError? {
        fatalError("Unresolved error: \(nserror), \(nserror.userInfo)")
      }
    }
    container.viewContext.automaticallyMergesChangesFromParent = true
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
