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
    let alertManager = AlertManager(
      textField: textField,
      datePicker: datePicker,
      categoryName: categoryName,
      tableViewController: self)
    guard alertManager.manageAlerts() else { return }
    let expense = IncomeExpense(context: managedObjectContext)
    expense.amount = Double(textField.text ?? "0.00") ?? 0.00
    expense.date = datePicker.date
    expense.category = categoryName
    expense.isIncome = false
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
      controller.managedObjectContext = managedObjectContext
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
