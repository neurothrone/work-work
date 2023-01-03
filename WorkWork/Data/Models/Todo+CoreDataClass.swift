//
//  Todo+CoreDataClass.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-02.
//
//

import CoreData
import Foundation

@objc(Todo)
public class Todo: NSManagedObject {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Todo> {
    return NSFetchRequest<Todo>(entityName: String(describing: Todo.self))
  }
  
  @NSManaged public var title: String
  @NSManaged public var isDone: Bool
  @NSManaged public var createdDate: Date
  @NSManaged public var list: TodoList
  
  public override func awakeFromInsert() {
    super.awakeFromInsert()
    
    createdDate = .now
  }
}

extension Todo : Identifiable {}
