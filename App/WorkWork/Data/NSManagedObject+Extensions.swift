//
//  NSManagedObject+Extensions.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-03.
//

import CoreData

extension NSManagedObject {
  func save(using context: NSManagedObjectContext) {
    CoreDataProvider.save(using: context)
  }
  
  func delete(using context: NSManagedObjectContext) {
    CoreDataProvider.delete(object: self, using: context)
  }
}

