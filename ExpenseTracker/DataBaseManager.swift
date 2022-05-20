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
  private var category = [Category]()
  private var incomeExpense = [IncomeExpense]()
  private var income = [IncomeExpense]()
  private var expense = [IncomeExpense]()
  private var incomeCategory = [IncomeCategory]()
  // MARK: - Expense Category
  func addCategory(_ category: CategoryEntity) {
    let categorySQL = Category(context: managedObjectContext)
    categorySQL.name = category.name
    do {
      try managedObjectContext.save()
    } catch {
      fatalError("Error \(error)")
    }
  }
  func deleteCategory(at index: Int) {
    let object = category[index]
    managedObjectContext.delete(object)
    save()
  }
  func updateCategory(_ newCategory: Category, at indexPath: IndexPath) {
    let fetchRequest = Category.fetchRequest()
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
  func getCategory() -> [Category] {
    let fetchRequest = Category.fetchRequest()
    category.removeAll()
    do {
      category = try managedObjectContext.fetch(fetchRequest)
    } catch {
      let nserror = error as NSError
      fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
    }
    return category
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
}
