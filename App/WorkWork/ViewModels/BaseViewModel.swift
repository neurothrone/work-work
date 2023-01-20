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
    MyApp.SystemImage.plusCircle
  }
  
  // Returns the icon to show when showing or hiding the text field
  var activeModeSystemName: String {
    switch actionMode {
    case .add, .edit:
      return MyApp.SystemImage.noActionMode
    default:
      return addSystemImage
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
  
  func delete(_ entity: T, using context: NSManagedObjectContext) {
    // If the entity that will be deleted is also actively being edited
    if actionMode == .edit,
       let selection,
       selection == entity {
      withAnimation(.linear) {
        title = ""
        actionMode = nil
        isTextFieldFocused = false
      }
    }
    
    withAnimation(.linear) {
      entity.delete(using: context)
    }
  }
}
