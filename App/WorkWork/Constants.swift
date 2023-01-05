//
//  Constants.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-02.
//

enum MyApp {
  static let name = "WorkWork"
  
  enum CKConfig {
    static let containerName = "Entities"
    static let sharedAppGroup = "group.workWork"
    static let cloudContainerID = "iCloud.workWork"
  }
  
  enum SystemImage {
    static let settings = "gear"
    static let showAddListTextField = "folder.badge.plus"
    static let quickAddList = "folder.fill.badge.plus"
    static let moreOptionsAddList = "square.grid.3x1.folder.fill.badge.plus"
    static let dismissKeyboard = "keyboard.chevron.compact.down.fill"
    
    static let showAddTodoTextField = "plus.circle.fill"
    static let addTodo = "plus.circle"
    static let todoIsDone = "checkmark.circle.fill"
    static let todoIsNotDone = "x.circle"
    static let circle = "circle"
    
    static let editActionMode = "pencil.circle"
    static let noActionMode = "circle.slash"
    
    static let folder = "folder"
    
    static let delete = "trash"
    static let edit = "pencil"
  }
  
  enum AppStorage {
    static let selectedColor = "selectedColor"
    static let isOnboardingPresented = true
    static let selectedScreen = "selectedScreen"
    
  }
  
  enum Link {
    static let svgRepo = "https://www.svgrepo.com/"
  }
}
