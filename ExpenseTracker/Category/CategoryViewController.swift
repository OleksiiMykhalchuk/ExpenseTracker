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
  var dataBaseManager: DataBaseManager!
  weak var delegate: CategoryPickerViewControllerDelegate?
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
  }
}
// MARK: - UITableViewDataSource
extension CategoryViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell")
    cell!.textLabel?.font = R.font.interMedium(size: 14)
    cell!.textLabel!.text = dataBaseManager.getCategory()[indexPath.row].name
    cell?.accessoryType = .detailDisclosureButton
    return cell!
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataBaseManager.getCategory().count
  }
  func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
    guard let controller = storyboard?.instantiateViewController(withIdentifier: "detail") as?
            CategoryDetailViewController else { return }
    controller.delegate = self
    controller.categoryToEdit = dataBaseManager.getCategory()[indexPath.row]
    controller.indexToEdit = indexPath
    controller.dataBaseManager = dataBaseManager
    navigationController?.pushViewController(controller, animated: true)
  }
  func tableView(_ tableView: UITableView,
                 commit editingStyle: UITableViewCell.EditingStyle,
                 forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      dataBaseManager.deleteCategory(dataBaseManager.getCategory()[indexPath.row])
      tableView.deleteRows(at: [indexPath], with: .left)
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
      let categoryName = dataBaseManager.getCategory()[indexPath.row].name
      delegate.categoryPicker(self, didPick: categoryName)
    }
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
// MARK: - CategoryDetail Delegate
extension CategoryViewController: CategoryDetailViewControllerDelegate {
  func categoryDetailViewControllerDidCansel(_ controller: CategoryDetailViewController) {
    navigationController?.popViewController(animated: true)
  }
  func categoryDetailViewController(_ controller: CategoryDetailViewController, didFinishAdding category: String) {
    dataBaseManager.addCategory(.init(id: UUID().uuidString, name: category))
    tableView.reloadData()
    navigationController?.popViewController(animated: true)
  }
  func categoryDetailViewController(_ controller: CategoryDetailViewController,
                                    didFinishEditing category: CategoryEntity) {
    dataBaseManager.updateCategory(category)
    tableView.reloadData()
    navigationController?.popViewController(animated: true)
  }
}
