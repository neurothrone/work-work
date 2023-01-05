//
//  BaseViewModel.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-05.
//

import CoreData
import SwiftUI

protocol CanCreateEntity {
  func createEntity(using context: NSManagedObjectContext)
}

class BaseViewModel<T: MoveableEntity>: ObservableObject, CanCreateEntity {
  func createEntity(using context: NSManagedObjectContext) {
    fatalError("Not implemented.")
  }
  
  enum ActionMode {
    case add,
         edit
  }
  
  @Published var isTextFieldFocused: Bool = false
  @Published var title = ""
  @Published var actionMode: ActionMode? = nil
  @Published var selection: T? = nil
  
  var addSystemImage: String {
    "plus.circle"
  }
  
  var activeModeSystemName: String {
    switch actionMode {
    case .add:
      return addSystemImage
    case .edit:
      return MyApp.SystemImage.editActionMode
    default:
      return MyApp.SystemImage.noActionMode
    }
  }
  
  var activeModeText: String {
    switch actionMode {
    case .add:
      return "Showing Add Text Field"
    case .edit:
      return "Editing"
    default:
      return "Hidden Text Field"
    }
  }
  
  func changeActionMode() {
    withAnimation(.linear) {
      switch actionMode {
      case .add:
        isTextFieldFocused = false
        actionMode = nil
      case .edit:
        isTextFieldFocused = false
        title = ""
        selection = nil
        actionMode = nil
      case nil:
        actionMode = .add
      }
    }
  }
  
  func changeToEditingOf(_ entity: T) {
    actionMode = .edit
    title = entity.title
    selection = entity
  }
  
  func addOrUpdate(using context: NSManagedObjectContext) {
    if let selection {
      selection.title = title
      selection.save(using: context)
      
      withAnimation(.linear) {
        self.selection = nil
        actionMode = nil
      }
    } else {
      createEntity(using: context)
      
      withAnimation(.linear) {
        isTextFieldFocused = true
      }
    }
    
    withAnimation(.linear) {
      title = ""
    }
  }
  
  func delete(entity: TodoList, using context: NSManagedObjectContext) {
    withAnimation {
      entity.delete(using: context)
    }
    
    guard actionMode == .edit else { return }
    
    withAnimation(.linear) {
      title = ""
      actionMode = nil
    }
  }
}
