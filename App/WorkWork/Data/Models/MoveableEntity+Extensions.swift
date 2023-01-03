//
//  MoveableEntity+Extensions.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-03.
//

import CoreData

extension MoveableEntity: MoveableNSManagedObject {}

extension MoveableEntity {
  static func allByOrder<T: MoveableEntity>(predicate: NSPredicate? = nil) -> NSFetchRequest<T> {
    let request: NSFetchRequest<T> = NSFetchRequest(entityName: String(describing: T.self))
    request.sortDescriptors = [NSSortDescriptor(keyPath: \T.order, ascending: true)]
    request.predicate = predicate
    return request
  }
}
