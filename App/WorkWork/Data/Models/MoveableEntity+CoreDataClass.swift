//
//  MoveableEntity+CoreDataClass.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-03.
//
//

import CoreData

@objc(MoveableEntity)
public class MoveableEntity: BaseEntity {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<MoveableEntity> {
    return NSFetchRequest<MoveableEntity>(entityName: String(describing: MoveableEntity.self))
  }
  
  @NSManaged public var order: Int16
}
