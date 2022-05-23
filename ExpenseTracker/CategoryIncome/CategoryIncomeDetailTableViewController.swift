//
//  CategoryIncomeDetailTableViewController.swift
//  ExpenseTracker
//
//  Created by Oleksii Mykhalchuk on 5/13/22.
//

import UIKit
import CoreData

protocol CategoryIncomeDetailTableViewControllerDelegate: AnyObject {
  func categoryIncomeDidCancel(_ controller: CategoryIncomeDetailTableViewController)
  func categoryIncomeDetail(_ controller: CategoryIncomeDetailTableViewController, didFinishAdding category: String)
  func categoryIncomeDetail(
    _ controller: CategoryIncomeDetailTableViewController,
    didFinishEditing category: IncomeCategoryEntity)
}

class CategoryIncomeDetailTableViewController: UITableViewController {
  var dataBaseManager: DataBaseManager!
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var navigationBar: UINavigationBar!
  weak var delegate: CategoryIncomeDetailTableViewControllerDelegate?
  var categoryToEdit: IncomeCategoryEntity?
  var indexPath: IndexPath?
  @IBAction func cancel() {
    delegate?.categoryIncomeDidCancel(self)
  }
  @IBAction func done() {
    if let temp = categoryToEdit {
      delegate?.categoryIncomeDetail(self, didFinishEditing: .init(id: temp.id, name: textField.text!))
    } else {
      let category = textField.text!
      delegate?.categoryIncomeDetail(self, didFinishAdding: category)
    }
  }
    override func viewDidLoad() {
        super.viewDidLoad()
      navigationBar.topItem?.title = R.string.localization.addCategory()
      if categoryToEdit != nil {
        navigationBar.topItem?.title = R.string.localization.editCategory()
        textField.text = categoryToEdit?.name
      }
      textField.becomeFirstResponder()
    }
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 0
  }
}
