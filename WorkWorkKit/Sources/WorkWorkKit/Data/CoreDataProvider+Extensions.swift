//
//  CoreDataProvider+Extensions.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-03.
//

import CoreData

extension CoreDataProvider {
  public static func save(using context: NSManagedObjectContext) {
    guard context.hasChanges else { return }
    
    do {
      try context.save()
    } catch {
      context.rollback()
#if DEBUG
      let nsError = error as NSError
      assertionFailure("❌ -> Failed to save context. Error: \(nsError), \(nsError.userInfo)")
#endif
    }
  }
  
  public static func delete<T: NSManagedObject>(
    object: T,
    using context: NSManagedObjectContext
  ) {
    context.delete(object)
    save(using: context)
  }
}


