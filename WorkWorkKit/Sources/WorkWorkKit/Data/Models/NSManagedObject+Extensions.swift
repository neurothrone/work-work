//
//  NSManagedObject+Extensions.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-03.
//

import CoreData

extension NSManagedObject {
  public func save(using context: NSManagedObjectContext) {
    CoreDataProvider.save(using: context)
  }
  
  public func delete(using context: NSManagedObjectContext) {
    CoreDataProvider.delete(object: self, using: context)
  }
  
  public static func getBy<T: NSManagedObject>(id: String, using context: NSManagedObjectContext) -> T? {
    let request: NSFetchRequest<T> = NSFetchRequest(entityName: String(describing: T.self))
    request.fetchLimit = 1
    
    do {
      return try context.fetch(request).first
    } catch {
      print("❌ -> Failed to fetch Core Data entity: (\(String(describing: T.self))")
      return nil
    }
  }
  
  public static func all<T: NSManagedObject>(using context: NSManagedObjectContext) -> [T] {
    let request: NSFetchRequest<T> = NSFetchRequest(entityName: String(describing: T.self))
    
    do {
      return try context.fetch(request)
    } catch {
      print("❌ -> Failed to fetch Core Data entities: (\(String(describing: T.self))")
      return []
    }
  }
}

