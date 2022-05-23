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
  private var category = [CategoryEntity]()
  private var incomeExpense = [IncomeExpense]()
  private var income = [IncomeExpense]()
  private var expense = [IncomeExpense]()
  private var incomeCategory = [IncomeCategory]()
  // MARK: - Expense Category
  func addCategory(_ category: CategoryEntity) {
    let categorySQL = Category(context: managedObjectContext)
    categorySQL.id = category.id
    categorySQL.name = category.name
    do {
      try managedObjectContext.save()
    } catch {
      AlertManager.alertOnError(message: "Save Error \(error)")
    }
  }
  func deleteCategory(_ category: CategoryEntity) {
    let fetchRequest = Category.fetchRequest()
    fetchRequest.fetchLimit = 1
    fetchRequest.predicate = NSPredicate(format: "id == %@", category.id)
    var items: [Category] = []
    do {
      items = try managedObjectContext.fetch(fetchRequest)
      managedObjectContext.delete(items.first!)
    } catch {
      AlertManager.alertOnError(message: "Fetch Error \(error)")
    }
    saveManagedObjectContext()
  }
  func updateCategory(_ newCategory: CategoryEntity) {
    let fetchRequest = Category.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "id == %@", newCategory.id)
    fetchRequest.fetchLimit = 1
    var item: [Category] = []
    do {
      item = try managedObjectContext.fetch(fetchRequest)
    } catch {
      AlertManager.alertOnError(message: "Fetch Error \(error)")
    }
    item.first?.name = newCategory.name
    do {
      try managedObjectContext.save()
    } catch {
      AlertManager.alertOnError(message: "Saving Error \(error)")
    }
  }
  func getCategory() -> [CategoryEntity] {
    let fetchRequest = Category.fetchRequest()
    var items: [Category] = []
    do {
      items = try managedObjectContext.fetch(fetchRequest)
    } catch {
      let nserror = error as NSError
      fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
    }
    return items.map{ CategoryEntity(id: $0.id, name: $0.name) }
  }
  // MARK: - Income Category
  func addIncomeCategory(_ category: IncomeCategoryEntity) {
    let categorySQL = IncomeCategory(context: managedObjectContext)
    categorySQL.name = category.name
    do {
      try managedObjectContext.save()
    } catch {
      fatalError("Error \(error)")
    }
  }
  func deleteIncomeCategory(at index: Int) {
    let object = incomeCategory[index]
    managedObjectContext.delete(object)
    save()
  }
  func updateIncomeCategory(_ newCategory: IncomeCategory, at indexPath: IndexPath) {
    let fetchRequest = IncomeCategory.fetchRequest()
    let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
    fetchRequest.sortDescriptors = [sortDescriptor]
    let fetchResutsController = NSFetchedResultsController(
      fetchRequest: fetchRequest,
      managedObjectContext: managedObjectContext,
      sectionNameKeyPath: nil,
      cacheName: nil)
    do {
      try fetchResutsController.performFetch()
    } catch {
      fatalError()
    }
    var object = fetchResutsController.object(at: indexPath)
    object = newCategory
    save()
  }
  func getIncomeCategory() -> [IncomeCategory] {
    let fetchRequest = IncomeCategory.fetchRequest()
    incomeCategory.removeAll()
    do {
      incomeCategory = try managedObjectContext.fetch(fetchRequest)
    } catch {
      let nserror = error as NSError
      fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
    }
    return incomeCategory
  }
  // MARK: - Income Expense Table
  func getIncomeExpense() -> ([IncomeExpense], [IncomeExpense],[IncomeExpense]) {
    let fetchRequest = IncomeExpense.fetchRequest()
    let sortDescriptor = NSSortDescriptor(key: "objectID", ascending: false)
    fetchRequest.sortDescriptors = [sortDescriptor]
    incomeExpense.removeAll()
    income.removeAll()
    expense.removeAll()
    do {
      incomeExpense = try managedObjectContext.fetch(fetchRequest)
      for item in incomeExpense {
        if item.isIncome {
          income.append(item)
        } else {
          expense.append(item)
        }
      }
    } catch {
      let nserror = error as NSError
      fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
    }
    return (incomeExpense, income, expense)
  }
  func addIncomeExpense(_ incomeExpense: IncomeExpenseEntity) {
    let incomeExpenseSQL = IncomeExpense(context: managedObjectContext)
    incomeExpenseSQL.amount = incomeExpense.amount
    incomeExpenseSQL.category = incomeExpense.category
    incomeExpenseSQL.date = incomeExpense.date
    incomeExpenseSQL.isIncome = incomeExpense.isIncome
    save()
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
  func saveManagedObjectContext() {
    do {
      try managedObjectContext.save()
    } catch {
      AlertManager.alertOnError(message: "Save Error \(error)")
    }
  }
}
