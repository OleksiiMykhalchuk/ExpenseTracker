//
//  CategoryDetailViewController.swift
//  ExpenseTracker
//
//  Created by Oleksii Mykhalchuk on 5/8/22.
//

import UIKit

class CategoryDetailViewController: UITableViewController {
    // MARK: - Outlets
  @IBOutlet weak var textField: UITextField!
  // MARK: - Variables
  var categoryName: String?
  var barButton = UIBarButtonItem()
  // MARK: - Actions
  @IBAction func doneButton() {
    dismiss(animated: true)
  }
    override func viewDidLoad() {
        super.viewDidLoad()
      textField.becomeFirstResponder()
      title = "Add Category"
      textField.text = categoryName
      navigationItem.setRightBarButton(barButton, animated: true)
    }
}
