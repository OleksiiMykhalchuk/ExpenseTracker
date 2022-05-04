//
//  AddExpenseContentViewController.swift
//  ExpenseTracker
//
//  Created by Oleksii Mykhalchuk on 5/3/22.
//

import UIKit

class AddExpenseContentViewController: UITableViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var addButton: UIButton!
    @IBAction func buttonPressed() {
        textField.text = ""
        let alert = UIAlertController(
            title: NSLocalizedString("Saved", comment: "AddExpense alert: title"),
            message: NSLocalizedString("Success!!!\nAmount: ", comment: "AddExpense alert: message"),
            preferredStyle: .alert)
        let action = UIAlertAction(
            title: "OK",
            style: .default,
            handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: {self.buttonPressed()})
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = UIFont(name: "Inter", size: 12)
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
        cell.layer.borderColor = UIColor(named: "Green2")?.cgColor
    }
}
