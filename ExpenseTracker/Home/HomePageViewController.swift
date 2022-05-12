//
//  HistoryViewController.swift
//  ExpenseTracker
//
//  Created by Oleksii Mykhalchuk on 5/6/22.
//

import UIKit
import CoreData

class HomePageViewController: UIViewController {
  @IBOutlet weak var viewTotals: UIView!
  @IBOutlet weak var tableView: UITableView!
  // MARK: - Variables
  var managedObjectContext: NSManagedObjectContext?
  lazy var fetchResultsController: NSFetchedResultsController<Expense> = {
    let fetchRequest = NSFetchRequest<Expense>()
    let entity = Expense.entity()
    fetchRequest.entity = entity
    let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
    fetchRequest.sortDescriptors = [sortDescriptor]
    let fetchResultsController = NSFetchedResultsController(
      fetchRequest: fetchRequest,
      managedObjectContext: managedObjectContext!,
      sectionNameKeyPath: nil,
      cacheName: nil)
    fetchResultsController.delegate = self
    return fetchResultsController
  }()
    override func viewDidLoad() {
        super.viewDidLoad()
      tableView.delegate = self
      tableView.dataSource = self
      showBackgroundView()
      configureViewTotals()
      performFetch()
      configureTitleTextAttributes()
    }
  deinit {
    fetchResultsController.delegate = nil
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    print("viewWillAppear HomePage")
    performFetch()
    tableView.reloadData()
  }
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
  private func configureViewTotals() {
    viewTotals.backgroundColor = UIColor(named: "Green2")
    viewTotals.clipsToBounds = false
    viewTotals.layer.masksToBounds = false
    viewTotals.layer.shadowColor = UIColor.lightGray.cgColor
    viewTotals.layer.shadowOffset = CGSize(width: 0, height: 0)
    viewTotals.layer.shadowRadius = 15.0
    viewTotals.layer.shadowOpacity = 1.0
    viewTotals.layer.cornerRadius = 20
    viewTotals.subviews.forEach { view in
      if let label = view as? UILabel {
        label.textColor = .white
      }
    }
  }
  private func performFetch() {
    do {
      try fetchResultsController.performFetch()
    } catch {
      fatalError("Error \(error)")
    }
  }
  private func configureDate(_ date: Date, dateFormat: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateFormat
    let dateString = dateFormatter.string(from: date)
    return dateString
  }
  private func configureNumberAsCurrancy(
    _ number: NSNumber,
    numberStyle: NumberFormatter.Style,
    currencyCode: String) -> String {
      let formatter = NumberFormatter()
      formatter.numberStyle = numberStyle
      formatter.currencyCode = currencyCode
      let numberString = formatter.string(from: number)
      return numberString!
  }
}
// MARK: - TableView Delegate
extension HomePageViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
// MARK: - TableView DataSource
extension HomePageViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as? HomeTableViewCell else {
      return UITableViewCell()
    }
    if fetchedResultsControllerIsEmpty(fetchResultsController) {
      cell.categoryLabel.text = "No Records"
      cell.categoryLabel.textColor = .red
      cell.amountLabel.text = ""
      cell.dateLabel.text = ""
      cell.isUserInteractionEnabled = false
      return cell
    } else {
      let object = fetchResultsController.object(at: indexPath)
        cell.categoryLabel.text = object.category
        let date = object.date
        cell.dateLabel.text = configureDate(date, dateFormat: "d MMM, YYYY")
        let number = NSNumber(value: object.amount)
        cell.amountLabel.textColor = .red
        cell.amountLabel.text = "- " + configureNumberAsCurrancy(
          number,
          numberStyle: NumberFormatter.Style.currency,
          currencyCode: "USD")
      cell.isUserInteractionEnabled = false
      return cell
    }
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if fetchedResultsControllerIsEmpty(fetchResultsController) {
      return 1
    } else {
      return 6
    }
  }
}
extension HomePageViewController: NSFetchedResultsControllerDelegate {
  func fetchedResultsControllerIsEmpty(_ controller: NSFetchedResultsController<Expense>) -> Bool {
    if controller.sections?[0].numberOfObjects == 0 {
      return true
    } else {
      return false
    }
  }
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
  }
}
