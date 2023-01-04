//
//  MoveableEntity+CoreDataClass.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-04.
//
//

import Foundation
import CoreData

@objc(MoveableEntity)
public class MoveableEntity: BaseEntity {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<MoveableEntity> {
      return NSFetchRequest<MoveableEntity>(entityName: "MoveableEntity")
  }

  @NSManaged public var order: Int16

}
