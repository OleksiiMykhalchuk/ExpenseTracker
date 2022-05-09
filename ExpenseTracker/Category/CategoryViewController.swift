//
//  CategoryViewController.swift
//  ExpenseTracker
//
//  Created by Oleksii Mykhalchuk on 5/5/22.
//

import UIKit

protocol CategoryPickerViewControllerDelegate: AnyObject {
  func categoryPicker(_ picker: CategoryViewController, didPick categoryName: String)
}

class CategoryViewController: UIViewController {
  var categoryArray = [String]()
  var categoryName: String?
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
    categoryArray = ["Groceries", "TV", "Clothes", "Health Care"]
  }
}
// MARK: - UITableViewDataSource
extension CategoryViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell")
      cell!.textLabel?.font = UIFont(name: "Inter", size: 14)
      cell!.textLabel!.text = categoryArray[indexPath.row]
    cell?.accessoryType = .detailDisclosureButton
      return cell!
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categoryArray.count
  }
  func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
    guard let controller = storyboard?.instantiateViewController(withIdentifier: "detail") as?
            CategoryDetailViewController else { return }
    controller.delegate = self
    controller.categoryToEdit = categoryArray[indexPath.row]
    controller.indexToEdit = indexPath.row
    navigationController?.pushViewController(controller, animated: true)
  }
  func tableView(_ tableView: UITableView,
                 commit editingStyle: UITableViewCell.EditingStyle,
                 forRowAt indexPath: IndexPath) {
    categoryArray.remove(at: indexPath.row)
    let indexPaths = [indexPath]
    tableView.deleteRows(at: indexPaths, with: .automatic)
  }
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "AddCategory" {
      if let controller = segue.destination as? CategoryDetailViewController {
        controller.delegate = self
      }
    } else if segue.identifier == "EditCategory" {
      if let controller = segue.destination as? CategoryDetailViewController {
        controller.delegate = self
        controller.categoryToEdit = categoryName
      }
    }
  }
}
// MARK: - UITableViewDelegate
extension CategoryViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let delegate = delegate {
      let categoryName = categoryArray[indexPath.row]
      delegate.categoryPicker(self, didPick: categoryName)
    }
    tableView.deselectRow(at: indexPath, animated: true)
    categoryName = categoryArray[indexPath.row]
  }
}
// MARK: - CategoryDetail Delegate
extension CategoryViewController: CategoryDetailViewControllerDelegate {
  func categoryDetailViewControllerDidCansel(_ controller: CategoryDetailViewController) {
    navigationController?.popViewController(animated: true)
  }
  func categoryDetailViewController(_ controller: CategoryDetailViewController, didFinishAdding category: String) {
    categoryArray.append(category)
    tableView.reloadData()
    navigationController?.popViewController(animated: true)
  }
  func categoryDetailViewController(_ controller: CategoryDetailViewController,
                                    didFinishEditing category: String,
                                    for index: Int) {
//    if let index = categoryArray.firstIndex(of: category) {
//      let indexPath = IndexPath(row: index, section: 0)
//      if let cell = tableView.cellForRow(at: indexPath) {
//        cell.textLabel?.text = category
//  }
  categoryArray[index] = category
  tableView.reloadData()
//    }
    navigationController?.popViewController(animated: true)
  }
}
