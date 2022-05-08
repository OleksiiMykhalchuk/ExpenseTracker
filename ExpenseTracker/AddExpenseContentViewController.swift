//
//  AddExpenseContentViewController.swift
//  ExpenseTracker
//
//  Created by Oleksii Mykhalchuk on 5/3/22.
//

import UIKit
import CoreData

class AddExpenseContentViewController: UITableViewController {
  // MARK: - Outlets
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var datePicker: UIDatePicker!
  @IBOutlet weak var addButton: UIButton!
  // MARK: - Actions
  @IBAction func buttonPressed() {
    guard manageAlerts() else { return }
    let expense = Expense(context: managedObjectContext)
    expense.amount = Double(textField.text ?? "0.00") ?? 0.00
    expense.date = datePicker.date
    expense.category = categoryName
    do {
      try managedObjectContext.save()
      print("*** Saved!!!")
    } catch {
      fatalError("Error \(error)")
    }
    textField.text = ""
  }
  // MARK: - Variables
  var categoryName: String = "No Category"
  var managedObjectContext: NSManagedObjectContext!
  var expenses = [Expense]()
  // MARK: - viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    nameLabel.text = categoryName
    textField.becomeFirstResponder()
//    let fetchRequest = NSFetchRequest<Expense>()
//    let entity = Expense.entity()
//    fetchRequest.entity = entity
//    do {
//      expenses = try managedObjectContext.fetch(fetchRequest)
//    } catch {
//      fatalError("Error \(error)")
//    }
//    for index in 0..<expenses.count {
//      print("*** amount: \(expenses[index].date)")
//    }
  }
  // MARK: - Table View Delegates
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
      guard let controller = segue.destination as? CategoryViewController else { return }
      controller.delegate = self
    }
  }
  // MARK: - Helper Methods
  private func showAlert(
    controllerTitle: String,
    message: String,
    preferredStyle: UIAlertController.Style,
    actionStyle: UIAlertAction.Style,
    handler: ((UIAlertAction) -> Void)? = nil) {
    let alert = UIAlertController(
      title: controllerTitle,
      message: message,
      preferredStyle: preferredStyle)
    let action = UIAlertAction(
      title: "OK",
      style: actionStyle,
      handler: handler)
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
  private func manageAlerts() -> Bool {
    let amount = textField.text ?? "Nothing"
    let formatter = DateFormatter()
    formatter.calendar = datePicker.calendar
    formatter.dateStyle = .medium
    let dateString = formatter.string(from: datePicker.date)
    if amount != "" {
      let title = NSLocalizedString("Saved", comment: "AddExpense alert: title")
      let message = NSLocalizedString(
        "Success!!!\nAmount: \(amount)\nCategory: \(categoryName)\nDate: \(dateString)",
        comment: "AddExpense alert: message")
      showAlert(
        controllerTitle: title,
        message: message,
        preferredStyle: .alert,
        actionStyle: .default)
      return true
    } else {
      let title = NSLocalizedString("Error", comment: "AddExpense alert: title")
      let message = NSLocalizedString(
        "Amount field should not be empty",
        comment: "AddExpense alert Error: message")
      showAlert(
        controllerTitle: title,
        message: message,
        preferredStyle: .actionSheet,
        actionStyle: .destructive) { _ in
          self.textField.placeholder = "$ 00.00" }
      textField.placeholder = "ERROR"
      return false
    }
  }
}
// MARK: - CategoryPickerViewControllerDelegate
extension AddExpenseContentViewController: CategoryPickerViewControllerDelegate {
  func categoryPicker(_ picker: CategoryViewController, didPick categoryName: String) {
    self.categoryName = categoryName
    navigationController?.popViewController(animated: true)
    nameLabel!.text = categoryName
  }
}
