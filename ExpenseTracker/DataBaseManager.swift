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
  private lazy var fetchResultsController: NSFetchedResultsController<IncomeExpense> = {
    let fetchRequest = NSFetchRequest<IncomeExpense>()
    let entity = IncomeExpense.entity()
    fetchRequest.entity = entity
    let sortDescriptor = NSSortDescriptor(key: "objectID", ascending: true)
    fetchRequest.sortDescriptors = [sortDescriptor]
    let fetchResultsController = NSFetchedResultsController(
      fetchRequest: fetchRequest,
      managedObjectContext: managedObjectContext,
      sectionNameKeyPath: nil,
      cacheName: nil)
      return fetchResultsController
  }()
  private var incomeExpense = [IncomeExpense]()
  func getIncomeExpense() -> [IncomeExpense]{
    incomeExpense.removeAll()
    for object in fetchResultsController.fetchedObjects! {
      incomeExpense.append(object)
    }
    return incomeExpense
  }
  func performFetch() {
    do {
      try fetchResultsController.performFetch()
    } catch {
      let nserror = error as NSError
      fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
    }
  }
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
