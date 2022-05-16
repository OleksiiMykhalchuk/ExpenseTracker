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
  func categoryIncomeDetail(_ controller: CategoryIncomeDetailTableViewController, didFinishEditing category: String, for indexPath: IndexPath)
}

class CategoryIncomeDetailTableViewController: UITableViewController {
  var managedObjectContext: NSManagedObjectContext!
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var navigationBar: UINavigationBar!
  weak var delegate: CategoryIncomeDetailTableViewControllerDelegate?
  var categoryToEdit: IncomeCategory?
  var indexPath: IndexPath?
  @IBAction func cancel() {
    delegate?.categoryIncomeDidCancel(self)
  }
  @IBAction func done() {
    if categoryToEdit != nil {
      delegate?.categoryIncomeDetail(self, didFinishEditing: textField.text!, for: indexPath!)
    } else {
      let category = textField.text!
      delegate?.categoryIncomeDetail(self, didFinishAdding: category)
    }
  }
    override func viewDidLoad() {
        super.viewDidLoad()
      navigationBar.topItem?.title = "Add Category"
      if categoryToEdit != nil {
        navigationBar.topItem?.title = "Edit Category"
        textField.text = categoryToEdit?.name
      }
      textField.becomeFirstResponder()
    }
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 0
  }
}
