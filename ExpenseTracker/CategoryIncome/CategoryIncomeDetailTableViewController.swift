//
//  CategoryIncomeDetailTableViewController.swift
//  ExpenseTracker
//
//  Created by Oleksii Mykhalchuk on 5/13/22.
//

import UIKit

class CategoryIncomeDetailTableViewController: UITableViewController {
  @IBAction func cancel() {
    dismiss(animated: true)
  }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 0
  }
}
