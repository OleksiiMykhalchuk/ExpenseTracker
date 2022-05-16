//
//  HistoryViewController.swift
//  ExpenseTracker
//
//  Created by Oleksii Mykhalchuk on 5/16/22.
//

import UIKit
import CoreData

class StatisticViewController: UIViewController {
  @IBOutlet weak var viewGraph: UIView!
  @IBOutlet weak var tableView: UITableView!
  var managedObjectContext: NSManagedObjectContext!
  lazy var fetchResultsController: NSFetchedResultsController<IncomeExpense> = {
    let fetchRequest = NSFetchRequest<IncomeExpense>()
    let entity = IncomeExpense.entity()
    fetchRequest.entity = entity
    let sortDescriptor = NSSortDescriptor(key: "amount", ascending: false)
    fetchRequest.sortDescriptors = [sortDescriptor]
    let fetchResultsController = NSFetchedResultsController(
      fetchRequest: fetchRequest,
      managedObjectContext: managedObjectContext,
      sectionNameKeyPath: nil,
      cacheName: nil)
    return fetchResultsController
  }()
    override func viewDidLoad() {
        super.viewDidLoad()
      title = "Statistic"
      tableView.dataSource = self
      let cellNib = UINib(nibName: "WalletCell", bundle: nil)
      tableView.register(cellNib, forCellReuseIdentifier: "WalletCell")
      performFetch()
    }
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    performFetch()
    tableView.reloadData()
  }
  func performFetch() {
    do {
      try fetchResultsController.performFetch()
    } catch {
      fatalError("Error \(error)")
    }
  }
}
// MARK: - StatisticViewController
extension StatisticViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let object = fetchResultsController.object(at: indexPath)
    let cell = tableView.dequeueReusableCell(withIdentifier: "WalletCell", for: indexPath) as? WalletCell
    if object.isIncome {

      cell?.categoryLabel.text = object.category
      cell?.dateLabel.text = ConfigureManager.configureDate(object.date, dateFormat: "d MMM, YYYY")
      cell?.amountLabel.text = "+ " +  ConfigureManager.configureNumberAsCurrancy(
        object.amount as NSNumber, numberStyle: .currency, currencyCode: "USD")
      cell?.amountLabel.textColor = R.color.green1()
      cell?.isUserInteractionEnabled = false
    }
    return cell!
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let numberOfObjects = fetchResultsController.sections![section].numberOfObjects
    return numberOfObjects
  }
}
