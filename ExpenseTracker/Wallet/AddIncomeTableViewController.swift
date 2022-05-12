//
//  AddIncomeTableViewController.swift
//  ExpenseTracker
//
//  Created by Oleksii Mykhalchuk on 5/12/22.
//

import UIKit

class AddIncomeTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
      tableView.backgroundColor = R.color.whiteDarkBackground()
    }
  // MARK: - Table View Delegates
  override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    guard let header = view as? UITableViewHeaderFooterView else { return }
      header.textLabel?.font = R.font.interRegular(size: 12)
  }
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 20
  }
  override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 1
  }
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50
  }
  override func tableView(
    _ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
      cell.layer.masksToBounds = false
      cell.layer.borderWidth = 1
      cell.layer.cornerRadius = 8
      cell.layer.borderColor = R.color.green2()?.cgColor
      cell.isUserInteractionEnabled = false
    }
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
    case 0:
        return "NAME"
    case 1:
        return "AMOUNT"
    case 2:
        return "DATE"
    default:
        return ""

    }
  }
}
