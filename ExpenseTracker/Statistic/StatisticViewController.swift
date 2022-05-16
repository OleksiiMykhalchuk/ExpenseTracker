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
  let label = UILabel()
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
      viewGraph.layer.borderWidth = 1
      label.text = "Graphs View"
      label.bounds.size = CGSize(width: 100, height: 20)
      label.center = viewGraph.center
      label.layer.borderWidth = 1
      viewGraph.addSubview(label)
      tableView.dataSource = self
      let cellNib = UINib(nibName: "WalletCell", bundle: nil)
      tableView.register(cellNib, forCellReuseIdentifier: "WalletCell")
      performFetch()
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
    let cellView = tableView.dequeueReusableCell(withIdentifier: "WalletCell", for: indexPath) as? WalletCell
    let object = fetchResultsController.object(at: indexPath)
    cellView?.categoryLabel.text = object.category
    cellView?.dateLabel.text = ConfigureManager.configureDate(object.date, dateFormat: "d MMM, YYYY")
    cellView?.amountLabel.text = ConfigureManager.configureNumberAsCurrancy(
      object.amount as NSNumber, numberStyle: .currency, currencyCode: "USD")
    return cellView!
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let numberOfObjects = fetchResultsController.sections![section].numberOfObjects
    return numberOfObjects
  }
}
