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
    container.loadPersistentStores(completionHandler: { (_, error) in // storeDescription
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
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
    saveManagedObjectContext()
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
    return items.map { CategoryEntity(id: $0.id, name: $0.name) }
  }
  // MARK: - Income Category
  func addIncomeCategory(_ category: IncomeCategoryEntity) {
    let categorySQL = IncomeCategory(context: managedObjectContext)
    categorySQL.id = category.id
    categorySQL.name = category.name
    saveManagedObjectContext()
  }
  func deleteIncomeCategory(_ category: IncomeCategoryEntity) {
    let fetchRequest = IncomeCategory.fetchRequest()
    fetchRequest.fetchLimit = 1
    fetchRequest.predicate = NSPredicate(format: "id == %@", category.id)
    var item: [IncomeCategory] = []
    do {
      item = try managedObjectContext.fetch(fetchRequest)
    } catch {
      AlertManager.alertOnError(message: "Fetch Error \(error)")
    }
    managedObjectContext.delete(item.first!)
    saveManagedObjectContext()
  }
  func updateIncomeCategory(_ newCategory: IncomeCategoryEntity) {
    let fetchRequest = IncomeCategory.fetchRequest()
    let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
    fetchRequest.sortDescriptors = [sortDescriptor]
    fetchRequest.predicate = NSPredicate(format: "id == %@", newCategory.id)
    fetchRequest.fetchLimit = 1
    var item: [IncomeCategory]  = []
    do {
      item = try managedObjectContext.fetch(fetchRequest)
    } catch {
      AlertManager.alertOnError(message: "Fetch Error \(error)")
    }
    item.first?.name = newCategory.name
    saveManagedObjectContext()
  }
  func getIncomeCategory() -> [IncomeCategoryEntity] {
    let fetchRequest = IncomeCategory.fetchRequest()
    var items: [IncomeCategory] = []
    do {
      items = try managedObjectContext.fetch(fetchRequest)
    } catch {
      AlertManager.alertOnError(message: "Fetch Error \(error)")
    }
    return items.map { IncomeCategoryEntity(id: $0.id, name: $0.name)}
  }
  // MARK: - Income Expense Table
  func getIncomeExpense() -> ([IncomeExpenseEntity], [IncomeExpenseEntity], [IncomeExpenseEntity]) {
    let fetchRequest = IncomeExpense.fetchRequest()
    let sortDescriptor = NSSortDescriptor(key: "objectID", ascending: false)
    fetchRequest.sortDescriptors = [sortDescriptor]
    var income: [IncomeExpense] = []
    var expense: [IncomeExpense] = []
    var incomeExpense: [IncomeExpense] = []
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
    let incExp = incomeExpense.map { IncomeExpenseEntity(
      amount: $0.amount,
      category: $0.category,
      date: $0.date,
      isIncome: $0.isIncome) }
    let inc = income.map { IncomeExpenseEntity(
      amount: $0.amount,
      category: $0.category,
      date: $0.date,
      isIncome: $0.isIncome) }
    let exp = expense.map { IncomeExpenseEntity(
      amount: $0.amount,
      category: $0.category,
      date: $0.date,
      isIncome: $0.isIncome) }
    return (incExp, inc, exp)
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
