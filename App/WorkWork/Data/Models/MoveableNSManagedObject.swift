//
//  MoveableNSManagedObject.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-03.
//

import CoreData

protocol MoveableNSManagedObject: NSManagedObject {
  var order: Int16 { get set }
  
  static func nextOrder<T: MoveableNSManagedObject>(for: T.Type) -> Int16
  static func move<T: MoveableNSManagedObject>(
    elements: [T],
    from source: IndexSet,
    to destination: Int,
    using context: NSManagedObjectContext
  )
}

extension MoveableNSManagedObject {
  static func nextOrder<T: MoveableNSManagedObject>(for: T.Type) -> Int16 {
    let results: [T] = T.all()
    let maxOrder: Int16? = results.max { $0.order < $1.order }?.order
    
    if let maxOrder = maxOrder {
      return maxOrder + 1
    } else {
      return .zero
    }
  }
  
  static func move<T: MoveableNSManagedObject>(
    elements: [T],
    from source: IndexSet,
    to destination: Int,
    using context: NSManagedObjectContext
  ) {
    var items = elements
    items.move(fromOffsets: source, toOffset: destination)
    
    for reverseIndex in stride(from: items.count - 1, through: .zero, by: -1) {
      items[reverseIndex].order = Int16(reverseIndex)
    }
    
    CoreDataProvider.save(using: context)
  }
}

