//
//  TodoList+Extensions.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-03.
//

import CoreData

//MARK: - Requests
extension TodoList {
  static var all: NSFetchRequest<TodoList> {
    let request = TodoList.fetchRequest()
    request.sortDescriptors = [.init(keyPath: \TodoList.order, ascending: true)]
    return request
  }
}
