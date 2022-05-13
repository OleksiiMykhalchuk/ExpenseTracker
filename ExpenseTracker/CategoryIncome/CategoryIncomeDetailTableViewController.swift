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
}

class CategoryIncomeDetailTableViewController: UITableViewController {
  var managedObjectContext: NSManagedObjectContext!
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var navigationBar: UINavigationBar!
  weak var delegate: CategoryIncomeDetailTableViewControllerDelegate?
  @IBAction func cancel() {
    delegate?.categoryIncomeDidCancel(self)
  }
  @IBAction func done() {
    let category = textField.text!
    delegate?.categoryIncomeDetail(self, didFinishAdding: category)
  }
    override func viewDidLoad() {
        super.viewDidLoad()
      navigationBar.topItem?.title = "Add Category"
      textField.becomeFirstResponder()
    }
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 0
  }
}
