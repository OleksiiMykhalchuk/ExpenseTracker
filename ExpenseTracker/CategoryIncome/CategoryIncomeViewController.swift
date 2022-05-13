//
//  CategoryIncomeTableViewController.swift
//  ExpenseTracker
//
//  Created by Oleksii Mykhalchuk on 5/13/22.
//

import UIKit

class CategoryIncomeViewController: UIViewController {
  @IBAction func addButton(_ sender: Any) {
  }
  @IBAction func cancel(_ sender: Any) {
    dismiss(animated: true)
  }
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var categoryLabel: UILabel!
  override func viewDidLoad() {
        super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    }
}
// MARK: - UITableViewDataSource
extension CategoryIncomeViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryIncomeCell")
    cell!.textLabel?.font = R.font.interRegular(size: 14)
    cell?.textLabel?.text = "Category"
    return cell!
  }
}
extension CategoryIncomeViewController: UITableViewDelegate {
}
