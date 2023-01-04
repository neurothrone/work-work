//
//  BaseEntity+CoreDataClass.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-04.
//
//

import CoreData
import Foundation

@objc(BaseEntity)
public class BaseEntity: NSManagedObject {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<BaseEntity> {
      return NSFetchRequest<BaseEntity>(entityName: "BaseEntity")
  }

  @NSManaged public var id: String
  @NSManaged public var createdDate: Date
  @NSManaged public var title: String
  
  public override func awakeFromInsert() {
    super.awakeFromInsert()
    
    id = UUID().uuidString
    createdDate = .now
  }
}

extension BaseEntity : Identifiable {}
