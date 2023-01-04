//
//  MoveableEntity+Extensions.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-03.
//

import CoreData
import SwiftUI

extension MoveableEntity: MoveableNSManagedObject {}

extension MoveableEntity {
  //MARK: - Requests
  static func allByOrder<T: MoveableEntity>(predicate: NSPredicate? = nil) -> NSFetchRequest<T> {
    let request: NSFetchRequest<T> = NSFetchRequest(entityName: String(describing: T.self))
    request.sortDescriptors = [NSSortDescriptor(keyPath: \T.order, ascending: true)]
    request.predicate = predicate
    return request
  }
  
  //MARK: - Data
  static func moveEntities<T: MoveableEntity>(
    _ entities: FetchedResults<T>,
    from source: IndexSet,
    to destination: Int,
    using context: NSManagedObjectContext
  ) {
    MoveableEntity.move(
      elements: Array(entities),
      from: source,
      to: destination,
      using: context
    )
  }
}

extension FetchedResults where Element == MoveableEntity {
  mutating func moveEntity(
    from source: IndexSet,
    to destination: Int,
    using context: NSManagedObjectContext
  ) {
    MoveableEntity.move(elements: Array(self), from: source, to: destination, using: context)
  }
}
