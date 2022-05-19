//
//  HistoryViewController.swift
//  ExpenseTracker
//
//  Created by Oleksii Mykhalchuk on 5/6/22.
//

import UIKit
import CoreData

class HomePageViewController: UIViewController {
  // MARK: - Outlets
  @IBOutlet weak var viewTotals: UIView!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var totalLabel: UILabel!
  @IBOutlet weak var incomeLabel: UILabel!
  @IBOutlet weak var expenseLabel: UILabel!
  @IBOutlet weak var seeAllBtn: UIButton!
  // MARK: - Variables
    var dataBaseManager: DataBaseManager!
  var totalBalance: Double!
  var totalExpense: Double!
  var totalIncome: Double!
  var expense: Double?
  var income: Double?
  var negative = ""
  let allView = UIView()
  let closeButton = UIButton()
  let label = UILabel()
  let seeAllTableView = UITableView()
  lazy var fetchResultsController: NSFetchedResultsController<IncomeExpense> = {
    let fetchRequest = NSFetchRequest<IncomeExpense>()
    let entity = IncomeExpense.entity()
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
  // MARK: - Actions
  @IBAction func seeAll() {
    allView.backgroundColor = .white
    allView.layer.cornerRadius = 20
    view.addSubview(allView)
    view.bringSubviewToFront(allView)
    allView.translatesAutoresizingMaskIntoConstraints = false

    let constraints = [
      allView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      allView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      allView.widthAnchor.constraint(equalToConstant: view.bounds.width - 40),
      allView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
      allView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -55)
    ]
    NSLayoutConstraint.activate(constraints)

    label.text = "Transaction History"
    label.font = R.font.interBold(size: 14)
    label.textColor = .black
    allView.addSubview(label)
    label.translatesAutoresizingMaskIntoConstraints = false
    let labelConstraints = [
      label.leadingAnchor.constraint(equalTo: allView.leadingAnchor, constant: 10),
      label.topAnchor.constraint(equalTo: allView.topAnchor, constant: 10)
    ]
    NSLayoutConstraint.activate(labelConstraints)

    closeButton.setTitle("Close", for: .normal)
    closeButton.setTitleColor(R.color.green2(), for: .normal)
    closeButton.titleLabel?.font = R.font.interBold(size: 14)
    allView.addSubview(closeButton)
    allView.bringSubviewToFront(closeButton)
    closeButton.translatesAutoresizingMaskIntoConstraints = false
    let closeButtonConstraints = [
      closeButton.trailingAnchor.constraint(equalTo: allView.trailingAnchor, constant: -10),
      closeButton.topAnchor.constraint(equalTo: allView.topAnchor, constant: 4)
    ]
    NSLayoutConstraint.activate(closeButtonConstraints)
    closeButton.addTarget(self, action: #selector(closePress(_:)), for: .touchUpInside)

    view.bringSubviewToFront(tableView)
    for constraint in tableView.constraints {
      tableView.removeConstraint(constraint)
    }
    tableView.translatesAutoresizingMaskIntoConstraints = false
    let tableConstraints = [
      tableView.leadingAnchor.constraint(equalTo: allView.leadingAnchor, constant: 10),
      tableView.trailingAnchor.constraint(equalTo: allView.trailingAnchor, constant: -10),
      tableView.topAnchor.constraint(equalTo: allView.topAnchor, constant: 30),
      tableView.bottomAnchor.constraint(equalTo: allView.bottomAnchor, constant: -10)
    ]
    NSLayoutConstraint.activate(tableConstraints)
  }
  @objc func closePress(_ sender: UIButton) {
    allView.removeFromSuperview()
    label.removeFromSuperview()
    closeButton.removeFromSuperview()
  }
    override func viewDidLoad() {
        super.viewDidLoad()
      tableView.delegate = self
      tableView.dataSource = self
      showBackgroundView()
      configureViewTotals()
      performFetch()
      configureTitleTextAttributes()
      totalLabel.text = ConfigureManager.configureNumberAsCurrancy(0.0, numberStyle: .currency, currencyCode: "USD")
      incomeLabel.text = ConfigureManager.configureNumberAsCurrancy(0.0, numberStyle: .currency, currencyCode: "USD")
      expenseLabel.text = ConfigureManager.configureNumberAsCurrancy(0.0, numberStyle: .currency, currencyCode: "USD")
    }
  deinit {
    fetchResultsController.delegate = nil
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    performFetch()
    tableView.reloadData()
    for object in fetchResultsController.fetchedObjects! where object.isIncome {
          income = object.amount
        break
    }
    totalIncome = 0.0
    for object in fetchResultsController.fetchedObjects! where object.isIncome {
        totalIncome += object.amount
    }
    for object in fetchResultsController.fetchedObjects! where !object.isIncome {
          expense = object.amount
        break
    }
    totalExpense = 0.0
    for object in fetchResultsController.fetchedObjects! where !object.isIncome {
        totalExpense += object.amount
    }
    totalBalance = totalIncome - totalExpense
    totalBalance < 0 ? (negative = "- ") : (negative = "")
  }
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if totalBalance != 0.0 {
    numberLabelAnimate(totalBalance, speed: 2.0) { balance in
      self.totalLabel.text = self.negative + "\(balance)"
      }
    }
    if let income = income {
      numberLabelAnimate(income, speed: 2.0) { balance in
        self.incomeLabel.text = "\(balance)"
      }
    }
    if let expense = expense {
      numberLabelAnimate(expense, speed: 2.0) { balance in
        self.expenseLabel.text = "\(balance)"
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
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: "HomeCell",
      for: indexPath) as? HomeTableViewCell else {
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
      var prefix = "- "
      cell.categoryLabel.textColor = R.color.blackWhiteText()
        cell.categoryLabel.text = object.category
        let date = object.date
        cell.dateLabel.text = configureDate(date, dateFormat: "d MMM, YYYY")
        let number = NSNumber(value: object.amount)
      if object.isIncome {
        prefix = "+ "
        cell.amountLabel.textColor = R.color.green1()
      } else {
        cell.amountLabel.textColor = .red
      }
        cell.amountLabel.text = prefix + configureNumberAsCurrancy(
          number,
          numberStyle: NumberFormatter.Style.currency,
          currencyCode: "USD")
      cell.isUserInteractionEnabled = false
      return cell
    }
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let count = fetchResultsController.sections![0].numberOfObjects
    if fetchedResultsControllerIsEmpty(fetchResultsController) {
      return 1
    } else {
      return count
    }
  }
}
extension HomePageViewController: NSFetchedResultsControllerDelegate {
  func fetchedResultsControllerIsEmpty(_ controller: NSFetchedResultsController<IncomeExpense>) -> Bool {
    if controller.sections?[0].numberOfObjects == 0 {
      return true
    } else {
      return false
    }
  }
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
  }
}

