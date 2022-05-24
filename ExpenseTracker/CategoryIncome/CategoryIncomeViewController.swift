//
//  CategoryIncomeTableViewController.swift
//  ExpenseTracker
//
//  Created by Oleksii Mykhalchuk on 5/13/22.
//

import UIKit
import CoreData

protocol CategoryIncomePickerDelegate: AnyObject {
  func categoryIncome(_ controller: CategoryIncomeViewController, didPick category: String)
}

class CategoryIncomeViewController: UIViewController {
  @IBAction func cancel(_ sender: Any) {
    dismiss(animated: true)
  }
  @IBOutlet weak var tableView: UITableView!
  var dataBaseManager: DataBaseManager!
  weak var delegate: CategoryIncomePickerDelegate?
  override func viewDidLoad() {
        super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    }
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "AddCategory" {
      let controller = segue.destination as? CategoryIncomeDetailTableViewController
      controller?.dataBaseManager = dataBaseManager
      controller?.delegate = self
    } else if segue.identifier == "EditCategory" {
      let controller = segue.destination as? CategoryIncomeDetailTableViewController
      controller?.delegate = self
      print("Segue edit category")
    }
  }
}
// MARK: - UITableViewDataSource
extension CategoryIncomeViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataBaseManager.getIncomeCategory().count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryIncomeCell")
    cell!.textLabel?.font = R.font.interRegular(size: 14)
    let object = dataBaseManager.getIncomeCategory()[indexPath.row]
    cell?.textLabel?.text = object.name
    return cell!
  }
}
extension CategoryIncomeViewController: UITableViewDelegate {
  func tableView(
    _ tableView: UITableView,
    commit editingStyle: UITableViewCell.EditingStyle,
    forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      dataBaseManager.deleteIncomeCategory(dataBaseManager.getIncomeCategory()[indexPath.row])
      tableView.deleteRows(at: [indexPath], with: .fade)
    }
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let delegate = delegate {
      let categoryName = dataBaseManager.getIncomeCategory()[indexPath.row].name
      delegate.categoryIncome(self, didPick: categoryName)
    }
    tableView.deselectRow(at: indexPath, animated: true)
  }
  func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
    let controller = storyboard?.instantiateViewController(
      withIdentifier: "Detail") as? CategoryIncomeDetailTableViewController
      controller?.delegate = self
    controller?.categoryToEdit = dataBaseManager.getIncomeCategory()[indexPath.row]
    controller?.indexPath = indexPath
    present(controller!, animated: true)
  }
}
// MARK: - CategoryIncomeDetailTableViewControllerDelegate
extension CategoryIncomeViewController: CategoryIncomeDetailTableViewControllerDelegate {
  func categoryIncomeDetail(_ controller: CategoryIncomeDetailTableViewController, didFinishAdding category: String) {
    let incomeCategory = IncomeCategoryEntity(id: UUID().uuidString, name: category)
    dataBaseManager.addIncomeCategory(incomeCategory)
    tableView.reloadData()
    dismiss(animated: true)
  }
  func categoryIncomeDidCancel(_ controller: CategoryIncomeDetailTableViewController) {
    dismiss(animated: true)
  }
  func categoryIncomeDetail(
    _ controller: CategoryIncomeDetailTableViewController,
    didFinishEditing category: IncomeCategoryEntity) {
    dataBaseManager.updateIncomeCategory(category)
      tableView.reloadData()
      dismiss(animated: true)
  }
}
