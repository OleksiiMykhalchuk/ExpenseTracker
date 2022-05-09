//
//  CategoryDetailViewController.swift
//  ExpenseTracker
//
//  Created by Oleksii Mykhalchuk on 5/8/22.
//

import UIKit

protocol CategoryDetailViewControllerDelegate: AnyObject {
  func categoryDetailViewControllerDidCansel(_ controller: CategoryDetailViewController)
  func categoryDetailViewController(_ controller: CategoryDetailViewController, didFinishAdding category: String)
  func categoryDetailViewController(_ controller: CategoryDetailViewController, didFinishEditing category: String, for index: Int)
}

class CategoryDetailViewController: UITableViewController {
    // MARK: - Outlets
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var doneButtonItem: UIBarButtonItem!
  // MARK: - Variables
  var categoryName: String?
  var barButton = UIBarButtonItem()
  var categoryToEdit: String?
  var indexToEdit: Int?
  weak var delegate: CategoryDetailViewControllerDelegate?
  // MARK: - Actions
  @IBAction func doneButton() {
    if let categoryToEdit = categoryToEdit {
      let newCategory = textField.text!
      delegate?.categoryDetailViewController(self, didFinishEditing: newCategory, for: indexToEdit!)
    } else {
      let newCategory = textField.text!
      delegate?.categoryDetailViewController(self, didFinishAdding: newCategory)
    }
  }
  @IBAction func cancelButton() {
    delegate?.categoryDetailViewControllerDidCansel(self)
  }
    override func viewDidLoad() {
        super.viewDidLoad()
      textField.becomeFirstResponder()
      title = "Add Category"
      textFieldConfiguration()
      if let categoryToEdit = categoryToEdit {
        textField.text = categoryToEdit
      }
  }
  override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    guard let header = view as? UITableViewHeaderFooterView else { return }
    header.textLabel!.font = UIFont(name: "Inter", size: 12)
  }
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 20
  }
  // MARK: - Helper Methods
  private func textFieldConfiguration() {
//    textField.text = categoryName
    navigationItem.setRightBarButton(barButton, animated: true)
    textField.layer.borderWidth = 1
    textField.layer.borderColor = UIColor(named: "Green2")?.cgColor
    textField.layer.cornerRadius = 8
    textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
    textField.leftViewMode = .always
  }
}
