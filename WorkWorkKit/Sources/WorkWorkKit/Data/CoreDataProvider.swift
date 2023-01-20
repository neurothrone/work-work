//
//  CoreDataProvider.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-03.
//

import CoreData

public final class CoreDataProvider {
  public static let shared: CoreDataProvider = .init()

  public static var preview: CoreDataProvider = {
    let provider = CoreDataProvider(inMemory: true)
    let context = provider.viewContext

    TodoList.Preview.generateSamples(using: context)

    return provider
  }()

  private let inMemory: Bool

  private lazy var container: NSPersistentCloudKitContainer = {
    let dataModelFileName = CKConfig.containerName
    
    // NOTE: Bundle.module and not Bundle.main
    // NOTE: Extension must be "momd"
    guard let modelURL = Bundle.module.url(
      forResource: dataModelFileName,
      withExtension: "momd"),
          let model = NSManagedObjectModel(contentsOf: modelURL)
    else { fatalError("Failed to find Data Model by the name \(dataModelFileName)") }
    
    container = NSPersistentCloudKitContainer(name: dataModelFileName, managedObjectModel: model)

#if !os(macOS)
    let storeURL = URL.storeURL(
      for: CKConfig.sharedAppGroup,
      databaseName: CKConfig.containerName
    )

    if inMemory {
      container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
    } else {
      let storeDescription = NSPersistentStoreDescription(url: storeURL)
      storeDescription.setOption(
        true as NSNumber,
        forKey: NSPersistentHistoryTrackingKey
      )
      storeDescription.setOption(
        true as NSNumber,
        forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey
      )

      storeDescription.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(
        containerIdentifier: CKConfig.cloudContainerID)
      container.persistentStoreDescriptions = [storeDescription]
    }
#else

#endif

    container.loadPersistentStores { store, error in
      if let error = error as NSError? {
        fatalError("❌ -> Unresolved error \(error), \(error.userInfo)")
      }
    }

    container.viewContext.automaticallyMergesChangesFromParent = true
    container.viewContext.name = "viewContext"
    container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    container.viewContext.undoManager = nil
    container.viewContext.shouldDeleteInaccessibleFaults = true

    return container
  }()

  public var viewContext: NSManagedObjectContext { container.viewContext }

  init(inMemory: Bool = false) {
    self.inMemory = inMemory
  }
}
