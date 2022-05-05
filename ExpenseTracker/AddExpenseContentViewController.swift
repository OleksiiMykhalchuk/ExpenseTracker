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
        let amount = textField.text ?? "Nothing"
        let formatter = DateFormatter()
        formatter.calendar = datePicker.calendar
        formatter.dateStyle = .medium
        let dateString = formatter.string(from: datePicker.date)
        if amount == "" {
            let alert = UIAlertController(
                title: NSLocalizedString("Error", comment: "AddExpense alert: title"),
                message: NSLocalizedString(
                    "Amount field should not be empty",
                    comment: "AddExpense alert Error: message"),
                preferredStyle: .actionSheet)
            let action = UIAlertAction(
                title: "OK",
                style: .destructive,
                handler: { _ in self.textField.placeholder = "$ 00.00" })
            textField.placeholder = "ERROR"
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            return
        }
        let alert = UIAlertController(
            title: NSLocalizedString("Saved", comment: "AddExpense alert: title"),
            message: NSLocalizedString(
                "Success!!!\nAmount: \(amount)\nCategory: \(categoryName)\nDate: \(dateString)",
                comment: "AddExpense alert: message"),
            preferredStyle: .alert)
        let action = UIAlertAction(
            title: "OK",
            style: .default,
            handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        textField.text = ""
    }
    var categoryName: String = "No Category"
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = categoryName
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    // MARK: - Navigatetion
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Category" {
             let controller = segue.destination as? CategoryViewController
                controller!.delegate = self
        }
    }
}
extension AddExpenseContentViewController: categoryPickerViewControllerDelegate {
    func categoryPicker(_ picker: CategoryViewController, didPick categoryName: String) {
        self.categoryName = categoryName
        navigationController?.popViewController(animated: true)
        nameLabel!.text = categoryName
    }
}
