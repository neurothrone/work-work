//
//  CustomError.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-03.
//

import Foundation

public enum CustomError: Swift.Error, CustomLocalizedStringResourceConvertible {
  case notFound(entityName: String),
       coreDataSave,
       unknownId(entityName: String, id: String),
       unknownError(message: String),
       deletionFailed(entityName: String),
       addFailed(entityName: String)
  
  public var localizedStringResource: LocalizedStringResource {
    switch self {
    case .addFailed(let entityName): return "❌ -> An error occurred trying to add \(entityName)"
    case .deletionFailed(let entityName): return "❌ -> An error occurred trying to delete \(entityName)"
    case .unknownError(let message): return "❌ -> An unknown error occurred: \(message)"
    case .unknownId(let entityName, let id): return "❌ -> No \(entityName) with an ID matching: \(id)"
    case .notFound(let entityName): return "❌ -> \(entityName) not found"
    case .coreDataSave: return "❌ -> Failed to save to CoreData"
    }
  }
}
