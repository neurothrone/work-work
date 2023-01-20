//
//  Constants.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-02.
//

enum MyApp {
  static let name = "WorkWork"
  
  enum AppStorage {
    static let prefersDarkMode = "prefersDarkMode"
    static let isOnboardingPresented = true
    static let selectedColor = "selectedColor"
    static let showTodosProgressBar = "showTodosProgressBar"
    static let todosProgressBarStyle = "todosProgressBarStyle"
    static let listStyle = "listStyle"
    static let todoCompletionStyle = "todoCompletionStyle"
    static let primaryButtonHandedness = "primaryButtonHandedness"
    static let todoRowVerticalPadding = "todoRowVerticalPadding"
  }
  
  enum SceneStorage {
    static let storedTodoListId = "AllTodoListsScreen.selectedList"
  }
  
  enum Link {
    static let svgRepo = "https://www.svgrepo.com/"
  }
  
  enum SystemImage {
    static let settings = "gear"
    static let infoCircle = "info.circle"
    static let ellipsisCircle = "ellipsis.circle"
    static let heartFill = "heart.fill"
    static let copyright = "c.circle"
    static let showAddListTextField = "folder.badge.plus"
    static let quickAddList = "folder.fill.badge.plus"
    static let moreOptionsAddList = "square.grid.3x1.folder.fill.badge.plus"
    static let dismissKeyboard = "keyboard.chevron.compact.down.fill"
    
    static let showAddTodoTextField = "plus.circle.fill"
    static let plusCircle = "plus.circle"
    static let todoIsDone = "checkmark.circle.fill"
    static let todoIsNotDone = "x.circle"
    static let circle = "circle"
    static let circleFill = "circle.fill"
    
    static let editActionMode = "pencil.circle"
    static let noActionMode = "square.slash"
    
    static let folder = "folder"
    
    static let delete = "trash"
    static let edit = "pencil"
    
    static let linkCircleFill = "link.circle.fill"
    
    static let moreOptions = "ellipsis.circle"
    static let uncheckAllTodos = "arrow.counterclockwise"
    static let deleteAllTodos = "trash"
  }
}
