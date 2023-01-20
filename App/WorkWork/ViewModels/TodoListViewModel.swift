//
//  TodoListViewModel.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-05.
//

import CoreData
import SwiftUI
import WorkWorkKit

final class TodoListViewModel: BaseViewModel<TodoList> {
  // NOTE: Can add other published properties here and change body of createEntity to include them
  
  override var addSystemImage: String {
    MyApp.SystemImage.showAddListTextField
  }
  
  override func createEntity(using context: NSManagedObjectContext) {
    _ = TodoList.create(with: title, using: context)
  }
}
