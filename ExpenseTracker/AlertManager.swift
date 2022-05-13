//
//  AlertManager.swift
//  ExpenseTracker
//
//  Created by Oleksii Mykhalchuk on 5/13/22.
//

import Foundation
import UIKit

class AlertManager {
  private var textField: UITextField
  private var datePicker: UIDatePicker
  private var categoryName: String
  private var tableViewController: UITableViewController
  init(
    textField: UITextField,
    datePicker: UIDatePicker,
    categoryName: String,
    tableViewController: UITableViewController) {
    self.textField = textField
    self.datePicker = datePicker
    self.categoryName = categoryName
    self.tableViewController = tableViewController
  }
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
      tableViewController.present(alert, animated: true, completion: nil)
  }
  func manageAlerts() -> Bool {
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
