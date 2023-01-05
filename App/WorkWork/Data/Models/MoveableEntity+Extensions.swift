//
//  MoveableEntity+Extensions.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-03.
//

import CoreData
import SwiftUI

extension MoveableEntity {
  //MARK: - Requests
  static func allByOrder<T: MoveableEntity>(predicate: NSPredicate? = nil) -> NSFetchRequest<T> {
    let request: NSFetchRequest<T> = NSFetchRequest(entityName: String(describing: T.self))
    request.sortDescriptors = [NSSortDescriptor(keyPath: \T.order, ascending: true)]
    request.predicate = predicate
    return request
  }
  
  //MARK: - Data  
  static func nextOrder<T: MoveableEntity>(
    for: T.Type,
    using context: NSManagedObjectContext
  ) -> Int16 {
    let results: [T] = T.all(using: context)
    let maxOrder: Int16? = results.max { $0.order < $1.order }?.order
    
    if let maxOrder {
      return maxOrder + 1
    } else {
      return .zero
    }
  }
  
  static func moveEntities<T: MoveableEntity>(
    _ entities: FetchedResults<T>,
    from source: IndexSet,
    to destination: Int,
    using context: NSManagedObjectContext
  ) {
    var items: [T] = entities.map { $0 }
    items.move(fromOffsets: source, toOffset: destination)
    
    for reverseIndex in stride(from: items.count - 1, through: .zero, by: -1) {
      items[reverseIndex].order = Int16(reverseIndex)
    }
    
    CoreDataProvider.save(using: context)
  }
}
