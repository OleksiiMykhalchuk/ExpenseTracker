//
//  CategoryDetailViewController.swift
//  ExpenseTracker
//
//  Created by Oleksii Mykhalchuk on 5/8/22.
//

import UIKit
import CoreData

protocol CategoryDetailViewControllerDelegate: AnyObject {
  func categoryDetailViewControllerDidCansel(_ controller: CategoryDetailViewController)
  func categoryDetailViewController(_ controller: CategoryDetailViewController, didFinishAdding category: String)
  func categoryDetailViewController(
    _ controller: CategoryDetailViewController,
    didFinishEditing category: CategoryEntity)
}

class CategoryDetailViewController: UITableViewController {
    // MARK: - Outlets
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var doneButtonItem: UIBarButtonItem!
  // MARK: - Variables
  private var categoryName: String?
  private var barButton = UIBarButtonItem()
  var categoryToEdit: CategoryEntity?
  var dataBaseManager: DataBaseManager!
  weak var delegate: CategoryDetailViewControllerDelegate?
  // MARK: - Actions
  @IBAction func doneButton() {

    if let temp = categoryToEdit {
      delegate!.categoryDetailViewController(
        self,
        didFinishEditing: .init(
          id: temp.id,
          name: textField.text!))
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
      title = R.string.localization.addCategory()
      textFieldConfiguration()
      if let categoryToEdit = categoryToEdit {
        textField.text = categoryToEdit.name
      }
  }
  override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    guard let header = view as? UITableViewHeaderFooterView else { return }
    header.textLabel!.font = R.font.interMedium(size: 12)
  }
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 20
  }
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50
  }
  // MARK: - Helper Methods
  private func textFieldConfiguration() {
    navigationItem.setRightBarButton(barButton, animated: true)
    textField.layer.borderWidth = 1
      textField.layer.borderColor = R.color.green2()?.cgColor
    textField.layer.cornerRadius = 8
    textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
    textField.leftViewMode = .always
  }
}
