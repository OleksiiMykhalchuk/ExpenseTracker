//
//  WalletViewController.swift
//  ExpenseTracker
//
//  Created by Oleksii Mykhalchuk on 5/10/22.
//

import UIKit
import CoreData

class WalletViewController: UIViewController {
  @IBOutlet weak var viewContent: UIView!
  @IBOutlet weak var tableView: UITableView!
  // MARK: - Variables
  var managedObjectContext: NSManagedObjectContext!
  lazy var fetchResultsController: NSFetchedResultsController<IncomeExpense> = {
    let fetchRequest = NSFetchRequest<IncomeExpense>()
    let entity = IncomeExpense.entity()
    fetchRequest.entity = entity
    let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
    fetchRequest.sortDescriptors = [sortDescriptor]
    fetchRequest.fetchBatchSize = 20
    let fetchResultsController = NSFetchedResultsController(
      fetchRequest: fetchRequest,
      managedObjectContext: managedObjectContext,
      sectionNameKeyPath: nil,
      cacheName: nil)
    return fetchResultsController
  }()
    override func viewDidLoad() {
        super.viewDidLoad()
      title = "Wallet"
      showBackgroundView()
      configureTitleTextAttributes()
      configureViewContent()
      let cellNib = UINib(
        nibName: "WalletCell",
        bundle: nil)
      tableView.register(cellNib, forCellReuseIdentifier: "WalletCell")
      tableView.delegate = self
      tableView.dataSource = self
      performFetch()
      print("Wallet")
    }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    performFetch()
    tableView.reloadData()
  }
  // MARK: - Private Methods
  private func configureTitleTextAttributes() {
    let nav = self.navigationController?.navigationBar
    nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
  }
  private func showBackgroundView() {
    let backgroundView = BackgroundView(frame: CGRect.zero)
    backgroundView.backgroundColor = .clear
    backgroundView.frame = view.bounds
    view.addSubview(backgroundView)
    view.sendSubviewToBack(backgroundView)
  }
  private func configureViewContent() {
    viewContent.layer.cornerRadius = 30
  }
  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "AddIncome" {
      guard let controller = segue.destination as? AddIncomeViewController else { return }
      controller.managedObjectContext = managedObjectContext
      controller.delegate = self
    }
  }
  // MARK: - performFetch
  func performFetch() {
    do {
      try fetchResultsController.performFetch()
    } catch {
      fatalError("Error \(error)")
    }
  }
}
// MARK: - UITableViewDelegates
extension WalletViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
  }
}
// MARK: - UITableViewDataSource
extension WalletViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: "WalletCell",
      for: indexPath) as? WalletCell else { return UITableViewCell() }
    if fetchedResultsControllerIsEmpty(fetchResultsController) {
      cell.amountLabel.text = ""
      cell.categoryLabel.text = "No Records"
      cell.categoryLabel.textColor = .red
      cell.dateLabel.text = ""
      cell.isUserInteractionEnabled = false
    } else {
      if fetchResultsController.object(at: indexPath).isIncome {
        let object = fetchResultsController.object(at: indexPath)
        let date = object.date
        let amount = NSNumber(value: object.amount)
        let category = object.category
        cell.dateLabel.text = ConfigureManager.configureDate(date, dateFormat: "d MMM, YYYY")
        cell.categoryLabel.text = category
        cell.amountLabel.text = ConfigureManager.configureNumberAsCurrancy(
          amount,
          numberStyle: .currency,
          currencyCode: "USD")
      }
    }
    cell.isUserInteractionEnabled = false
    return cell
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if fetchedResultsControllerIsEmpty(fetchResultsController) {
      return 1
    } else {
      let object = fetchResultsController.sections![section]
      return object.numberOfObjects
    }
  }
}
// MARK: - NSFetchedResultsControllerDelegate
extension WalletViewController: NSFetchedResultsControllerDelegate {
  func fetchedResultsControllerIsEmpty(_ controller: NSFetchedResultsController<IncomeExpense>) -> Bool {
    if controller.sections?[0].numberOfObjects == 0 {
      return true
    } else {
      return false
    }
  }
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.endUpdates()
  }
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.beginUpdates()
  }
}
// MARK: - AddIncomeViewControllerDelegate
extension WalletViewController: AddIncomeViewControllerDelegate {
  func addIncomeViewControllerDidReloadOnDismiss() {
    performFetch()
    tableView.reloadData()
  }
}
