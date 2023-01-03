//
//  NSManagedObject+Extensions.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-03.
//

import CoreData

extension NSManagedObject {
  private static var viewContext: NSManagedObjectContext {
#if DEBUG
    CoreDataProvider.preview.viewContext
#else
    CoreDataProvider.shared.viewContext
#endif
  }
  
  func save(using context: NSManagedObjectContext) {
    CoreDataProvider.save(using: context)
  }
  
  func delete(using context: NSManagedObjectContext) {
    CoreDataProvider.delete(object: self, using: context)
  }
  
  static func getBy<T: NSManagedObject>(id: String) -> T? {
    let request: NSFetchRequest<T> = NSFetchRequest(entityName: String(describing: T.self))
    request.fetchLimit = 1
    
    do {
      return try viewContext.fetch(request).first
    } catch {
      print("❌ -> Failed to fetch Core Data entity: (\(String(describing: T.self))")
      return nil
    }
  }
  
  static func all<T: NSManagedObject>() -> [T] {
    let request: NSFetchRequest<T> = NSFetchRequest(entityName: String(describing: T.self))
    
    do {
      return try viewContext.fetch(request)
    } catch {
      print("❌ -> Failed to fetch Core Data entities: (\(String(describing: T.self))")
      return []
    }
  }
}

