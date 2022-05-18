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
  @IBOutlet weak var totalLabel: UILabel!
  // MARK: - Variables
  var managedObjectContext: NSManagedObjectContext!
  var incomes = [IncomeExpense]()
  var totalBalance: Double!
  var totalIncome: Double!
  var totalExpense: Double!
  var negative = ""
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
      totalLabel.text = ConfigureManager.configureNumberAsCurrancy(0.0, numberStyle: .currency, currencyCode: "USD")
    }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    performFetch()
    tableView.reloadData()
    totalIncome = 0.0
    for object in fetchResultsController.fetchedObjects! where object.isIncome {
      totalIncome += object.amount
    }
    totalExpense = 0.0
    for object in fetchResultsController.fetchedObjects! where !object.isIncome {
      totalExpense += object.amount
    }
    totalBalance = totalIncome - totalExpense
    if totalBalance < 0 { negative = "- "} else { negative = ""}
  }
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if totalBalance != 0.0 {
      numberLabelAnimate(totalBalance, speed: 2.0) { balance in
        self.totalLabel.text = self.negative + "\(balance)"
      }
    }
  }
  func numberLabelAnimate(_ number: Double, speed: Double, completion: @escaping (String) -> Void) {
    let total = abs(Int(number))
    let duration = speed
    DispatchQueue.global().async {
      for number in 0...abs(total) {
        let sleepTime = Int32(duration/Double(total) * 1000000.0)
        usleep(useconds_t(sleepTime))
        let balance = ConfigureManager.configureNumberAsCurrancy(
          number as NSNumber,
          numberStyle: .currency,
          currencyCode: "USD")
        DispatchQueue.main.async {
          completion(balance)
        }
      }
    }
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
      incomes.removeAll()
      try fetchResultsController.performFetch()
      for object in fetchResultsController.fetchedObjects! where object.isIncome {
        incomes.append(object)
      }
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
      let object = incomes[indexPath.row]
      cell.categoryLabel.textColor = R.color.blackWhiteText()
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
    cell.isUserInteractionEnabled = false
    return cell
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if fetchedResultsControllerIsEmpty(fetchResultsController) {
      return 1
    } else {
      return incomes.count
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
    viewWillAppear(true)
    viewDidAppear(true)
  }
  func reloadOnDone() {
    viewWillAppear(true)
    viewDidAppear(true)
  }
}
