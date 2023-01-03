//
//  BaseEntity+CoreDataClass.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-03.
//
//

import CoreData

@objc(BaseEntity)
public class BaseEntity: NSManagedObject {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<BaseEntity> {
    return NSFetchRequest<BaseEntity>(entityName: String(describing: BaseEntity.self))
  }

  @NSManaged public var id: String
  @NSManaged public var title: String
  @NSManaged public var createdDate: Date
  
  public override func awakeFromInsert() {
    super.awakeFromInsert()
    
    id = UUID().uuidString
    createdDate = .now
  }
}

extension BaseEntity : Identifiable {}
