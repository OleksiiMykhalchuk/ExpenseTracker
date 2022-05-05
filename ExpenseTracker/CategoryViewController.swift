//
//  CategoryViewController.swift
//  ExpenseTracker
//
//  Created by Oleksii Mykhalchuk on 5/5/22.
//

import UIKit

protocol categoryPickerViewControllerDelegate: AnyObject {
    func categoryPicker(_ picker: CategoryViewController, didPick categoryName: String)
}

class CategoryViewController: UIViewController {
    var categoryArray: [String] = ["Groceries", "TV", "Clothes", "Health Care"]
    weak var delegate: categoryPickerViewControllerDelegate?
    @IBOutlet weak var tableView: UITableView!
    @IBAction func cancel() {
        dismiss(animated: true)
    }
    @IBAction func done() {
        dismiss(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
}
extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell")
        cell?.textLabel!.text = categoryArray[indexPath.row]
        return cell!
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let delegate = delegate {
            let categoryName = categoryArray[indexPath.row]
            delegate.categoryPicker(self, didPick: categoryName)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
