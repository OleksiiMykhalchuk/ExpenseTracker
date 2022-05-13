//
//  CategoryIncomeTableViewController.swift
//  ExpenseTracker
//
//  Created by Oleksii Mykhalchuk on 5/13/22.
//

import UIKit
import CoreData

protocol CategoryIncomePickerDelegate: AnyObject {
  func categoryIncome(_ controller: CategoryIncomeViewController, didPick category: String)
}

class CategoryIncomeViewController: UIViewController {
  @IBAction func cancel(_ sender: Any) {
    dismiss(animated: true)
  }
  @IBOutlet weak var tableView: UITableView!
  var managedObjectContext: NSManagedObjectContext!
  var delegate: CategoryIncomePickerDelegate?
  lazy var fetchResultsController: NSFetchedResultsController<IncomeCategory> = {
    let fetchRequest = NSFetchRequest<IncomeCategory>()
    let entity = IncomeCategory.entity()
    fetchRequest.entity = entity
    let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
    fetchRequest.sortDescriptors = [sortDescriptor]
    fetchRequest.fetchBatchSize = 20
    let fetchResultsController = NSFetchedResultsController(
      fetchRequest: fetchRequest,
      managedObjectContext: managedObjectContext,
      sectionNameKeyPath: nil,
      cacheName: nil)
    fetchResultsController.delegate = self
    return fetchResultsController
  }()
  override func viewDidLoad() {
        super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    performFetch()
    }
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "AddCategory" {
      let controller = segue.destination as? CategoryIncomeDetailTableViewController
      controller?.managedObjectContext = managedObjectContext
      controller?.delegate = self
    }
  }
  func performFetch() {
    do {
      try fetchResultsController.performFetch()
    } catch {
      fatalError("Error \(error)")
    }
  }
}
// MARK: - UITableViewDataSource
extension CategoryIncomeViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return fetchResultsController.sections![0].numberOfObjects
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryIncomeCell")
    cell!.textLabel?.font = R.font.interRegular(size: 14)
    let object = fetchResultsController.object(at: indexPath)
    cell?.textLabel?.text = object.name
    return cell!
  }
}
extension CategoryIncomeViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let category = fetchResultsController.object(at: indexPath)
      managedObjectContext.delete(category)
      do {
        try managedObjectContext.save()
      } catch {
        fatalError("Error \(error)")
      }
    }
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let delegate = delegate {
      let categoryName = fetchResultsController.object(at: indexPath).name
      delegate.categoryIncome(self, didPick: categoryName)
    }
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
// MARK: - CategoryIncomeDetailTableViewControllerDelegate
extension CategoryIncomeViewController: CategoryIncomeDetailTableViewControllerDelegate {
  func categoryIncomeDetail(_ controller: CategoryIncomeDetailTableViewController, didFinishAdding category: String) {
    let categorySQL = IncomeCategory(context: managedObjectContext)
    categorySQL.name = category
    do {
      try managedObjectContext.save()
    } catch {
      fatalError("Error \(error)")
    }
    dismiss(animated: true)
  }
  func categoryIncomeDidCancel(_ controller: CategoryIncomeDetailTableViewController) {
    dismiss(animated: true)
  }
}
// MARK: - NSFetchResultsControllerDelegate
extension CategoryIncomeViewController: NSFetchedResultsControllerDelegate {
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    print("*** Controller will change content")
    tableView.beginUpdates()
  }
  func controller(
    _ controller: NSFetchedResultsController<NSFetchRequestResult>,
    didChange anObject: Any,
    at indexPath: IndexPath?,
    for type: NSFetchedResultsChangeType,
    newIndexPath: IndexPath?) {
      switch type {
      case .insert:
          print("NSFetchResultsChangeInsert (object)")
          tableView.insertRows(at: [newIndexPath!], with: .fade)
      case .delete:
          print("NSFetchResultChangeDelete (object)")
          tableView.deleteRows(at: [indexPath!], with: .fade)
      case .update:
          print("NSFetchResultChangeUpdate (object)")
          if let cell = tableView.cellForRow(
            at: indexPath!) {
            let category = controller.object(at: indexPath!) as? Category
            cell.textLabel!.text = category!.name
          }
      case .move:
          print("NSFetchResultsChangeMove (object)")
          tableView.deleteRows(at: [indexPath!], with: .fade)
          tableView.insertRows(at: [newIndexPath!], with: .fade)
      @unknown default:
          print("NSFetchResults unknown type")
      }
    }
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    print("*** controllerDidChangeContent")
    tableView.endUpdates()
  }
}
