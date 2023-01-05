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
public class MoveableEntity: NSManagedObject {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<MoveableEntity> {
    return NSFetchRequest<MoveableEntity>(entityName: String(describing: MoveableEntity.self))
  }

  @NSManaged public var id: String
  @NSManaged public var createdDate: Date
  @NSManaged public var title: String
  @NSManaged public var order: Int16
  
  public override func awakeFromInsert() {
    super.awakeFromInsert()
    
    id = UUID().uuidString
    createdDate = .now
  }
}

extension MoveableEntity : Identifiable {}
