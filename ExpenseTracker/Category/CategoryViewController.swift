//
//  CategoryViewController.swift
//  ExpenseTracker
//
//  Created by Oleksii Mykhalchuk on 5/5/22.
//

import UIKit
import CoreData

protocol CategoryPickerViewControllerDelegate: AnyObject {
  func categoryPicker(_ picker: CategoryViewController, didPick categoryName: String)
}

class CategoryViewController: UIViewController {
  var categoryArray = [Category]()
  var categoryName: String?
  var dataBaseManager: DataBaseManager!
  weak var delegate: CategoryPickerViewControllerDelegate?
  lazy var fetchResultController: NSFetchedResultsController<Category> = {
    let fetchRequest = NSFetchRequest<Category>()
    let entity = Category.entity()
    fetchRequest.entity = entity
    let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
    fetchRequest.sortDescriptors = [sortDescriptor]
    fetchRequest.fetchBatchSize = 20
    let fetchResultsController = NSFetchedResultsController(
      fetchRequest: fetchRequest,
      managedObjectContext: managedObjectContext,
      sectionNameKeyPath: nil,
      cacheName: "Category")
    fetchResultsController.delegate = self
    return fetchResultsController
  }()
  // MARK: - Outlets
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var cancelButton: UIBarButtonItem!
  // MARK: - Actions
  @IBAction func cancel() {
    navigationController?.popViewController(animated: true)
  }
  @IBAction func done() {
    dismiss(animated: true)
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    performFetch()
  }
  deinit {
    fetchResultController.delegate = nil
  }
}
// MARK: - UITableViewDataSource
extension CategoryViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell")
    cell!.textLabel?.font = UIFont(name: "Inter", size: 14)
    cell!.textLabel!.text = fetchResultController.object(at: indexPath).name
    cell?.accessoryType = .detailDisclosureButton
    return cell!
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let count = fetchResultController.sections![section]
    return count.numberOfObjects
  }
  func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
    guard let controller = storyboard?.instantiateViewController(withIdentifier: "detail") as?
            CategoryDetailViewController else { return }
    controller.delegate = self
    controller.categoryToEdit = fetchResultController.object(at: indexPath)
    controller.indexToEdit = indexPath
    controller.dataBaseManager = dataBaseManager
    navigationController?.pushViewController(controller, animated: true)
  }
  func tableView(_ tableView: UITableView,
                 commit editingStyle: UITableViewCell.EditingStyle,
                 forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let category = fetchResultController.object(at: indexPath)
      managedObjectContext.delete(category)
      do {
        try managedObjectContext.save()
      } catch {
        fatalError("Error \(error)")
      }
    }
  }
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "AddCategory" {
      if let controller = segue.destination as? CategoryDetailViewController {
        controller.delegate = self
        controller.dataBaseManager = dataBaseManager
      }
    } else if segue.identifier == "EditCategory" {
      if let controller = segue.destination as? CategoryDetailViewController {
        controller.delegate = self
        controller.dataBaseManager = dataBaseManager
      }
    }
  }
}
// MARK: - UITableViewDelegate
extension CategoryViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let delegate = delegate {
      let categoryName = fetchResultController.object(at: indexPath).name
      delegate.categoryPicker(self, didPick: categoryName)
    }
    tableView.deselectRow(at: indexPath, animated: true)
    //    categoryName = categoryArray[indexPath.row]
  }
}
// MARK: - CategoryDetail Delegate
extension CategoryViewController: CategoryDetailViewControllerDelegate {
  func categoryDetailViewControllerDidCansel(_ controller: CategoryDetailViewController) {
    navigationController?.popViewController(animated: true)
  }
  func categoryDetailViewController(_ controller: CategoryDetailViewController, didFinishAdding category: String) {
      dataBaseManager.addCategory(.init(name: category))
    tableView.reloadData()
    navigationController?.popViewController(animated: true)
  }
  func categoryDetailViewController(_ controller: CategoryDetailViewController,
                                    didFinishEditing category: Category,
                                    for index: IndexPath) {
    var temp = fetchResultController.object(at: index)
    temp = category
    do {
      try managedObjectContext.save()
    } catch {
      fatalError("Error \(error)")
    }
    navigationController?.popViewController(animated: true)
  }
}
// MARK: - GetData from Category Table
extension CategoryViewController {
  func performFetch() {
    do {
      try fetchResultController.performFetch()
    } catch {
      fatalError("Error \(error)")
    }
  }
}
// MARK: - NSFetchResultsControllerDelegate
extension CategoryViewController: NSFetchedResultsControllerDelegate {
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
