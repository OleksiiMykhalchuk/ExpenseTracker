//
//  AddIncomeViewController.swift
//  ExpenseTracker
//
//  Created by Oleksii Mykhalchuk on 5/12/22.
//

import UIKit

class AddIncomeViewController: UIViewController {
  @IBOutlet weak var contentView: UIView!
  @IBOutlet weak var tableView: UITableView!
  @IBAction func close() {
    dismiss(animated: true)
  }
    override func viewDidLoad() {
        super.viewDidLoad()
      configureContentView()
      tableView.delegate = self
      tableView.dataSource = self
    }
  // MARK: - Helper Methods
  private func configureContentView() {
    contentView.backgroundColor = R.color.whiteDarkBackground()
    contentView.clipsToBounds = false
    contentView.layer.masksToBounds = false
    contentView.layer.shadowColor = UIColor.lightGray.cgColor
    contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
    contentView.layer.shadowRadius = 15.0
    contentView.layer.shadowOpacity = 1.0
    contentView.layer.cornerRadius = 20
  }
}
// MARK: - UITableViewDelegate
extension AddIncomeViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
    case 0:
        return "Section \(section)"
    case 1:
        return "Section \(section)"
    case 2:
        return "Section \(section)"
    case 3:
        return "Section \(section)"
    default:
        return ""
    }
  }
  func numberOfSections(in tableView: UITableView) -> Int {
    return 4
  }
}
// MARK: - UITableVieDataSource
extension AddIncomeViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddIncomeCell") else { return UITableViewCell() }
    return cell
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
}
