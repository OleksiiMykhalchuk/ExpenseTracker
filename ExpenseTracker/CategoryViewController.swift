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
  var categoryArray: [String] = ["Groceries", "TV", "Clothes", "Health Care"]
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
      cell!.textLabel?.font = UIFont(name: "Inter", size: 14)
      cell!.textLabel!.text = categoryArray[indexPath.row]
      return cell!
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categoryArray.count
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
  }
}
