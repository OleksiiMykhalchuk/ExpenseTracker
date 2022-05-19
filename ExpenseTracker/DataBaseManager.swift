//
//  DataBaseManager.swift
//  ExpenseTracker
//
//  Created by Denysov Illia on 18.05.2022.
//

import Foundation
import CoreData

class DataBaseManager {
    private lazy var managedObjectContext = persistentContainer.viewContext
    private lazy var persistentContainer: NSPersistentContainer = {
      let container = NSPersistentContainer(name: "ExpenseTracker")
      container.loadPersistentStores(completionHandler: { (storeDescription, error) in
        if let error = error as NSError? {
          fatalError("Unresolved error \(error), \(error.userInfo)")
        }
      })
      return container
    }()
    
    func addCategory(_ category: CategoryEntity) {
        let categorySQL = Category(context: managedObjectContext)
        categorySQL.name = category.name
        do {
          try managedObjectContext.save()
        } catch {
          fatalError("Error \(error)")
        }
    }

    func save() {
      let context = persistentContainer.viewContext
      if context.hasChanges {
        do {
          try context.save()
        } catch {
          let nserror = error as NSError
          fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
      }
    }
}