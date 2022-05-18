//
//  HistoryViewController.swift
//  ExpenseTracker
//
//  Created by Oleksii Mykhalchuk on 5/16/22.
//

import UIKit
import CoreData
import iOSDropDown

class StatisticViewController: UIViewController {
  // MARK: - Outlets
  @IBOutlet weak var viewGraph: UIView!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var dropDown: DropDown!
  @IBOutlet weak var segmentControl: UISegmentedControl!
  // MARK: - Action
  @IBAction func segmentChanged(_ sender: Any) {
    switch segmentControl.selectedSegmentIndex {
    case 0:
        segment = .day
        performFetch()
        tableView.reloadData()
    case 1:
        segment = .week
        performFetch()
        tableView.reloadData()
    case 2:
        segment = .month
        performFetch()
        tableView.reloadData()
    case 3:
        segment = .year
        performFetch()
        tableView.reloadData()
    default:
        return
    }
  }
  // MARK: - Private Variable
  private var segment: Segments = .day
  private var dateFilter: DateFilter = .day
  // MARK: - Enums
  enum Segments: Int {
    case day = 0, week, month, year
  }
  enum DateFilter: Int {
    case day = 0, week, month, year
  }
  // MARK: - Varibles
  var dropDownisIncome = true
  var managedObjectContext: NSManagedObjectContext!
  var dataIncome = [IncomeExpense]()
  var dataExpense = [IncomeExpense]()
  let now = Date()
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
      tableView.rowHeight = 60
      performFetch()
      dropDown.optionArray = ["Income", "Expense"]
      dropDown.optionIds = [0, 1]
      dropDown.selectedRowColor = R.color.green2()!
      dropDown.checkMarkEnabled = false
      dropDown.selectedIndex = 0
      dropDown.isSearchEnable = false
      dropDown.text = "Income"
      dropDown.didSelect(completion: {_, index, _ in
        if index == 0 {
          self.dropDownisIncome = true
          self.tableView.reloadData()
          self.performFetch()
        } else {
          self.dropDownisIncome = false
          self.tableView.reloadData()
          self.performFetch()
        }
      })
    }
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    performFetch()
    tableView.reloadData()
  }
  func performFetch() {
    do {
      try fetchResultsController.performFetch()
      dataIncome.removeAll()
      dataExpense.removeAll()
      if let dataFetched = fetchResultsController.fetchedObjects {
        for data in dataFetched {
          if data.isIncome {
            if segment.rawValue == filterByDate(now: Date(), dataDate: data.date).rawValue {
              dataIncome.append(data)
            }
          } else {
            if segment.rawValue == filterByDate(now: Date(), dataDate: data.date).rawValue {
              dataExpense.append(data)
            }
          }
        }
      }
    } catch {
      fatalError("Error \(error)")
    }
  }
  // MARK: - Private Methods
  private func filterByDate(now date: Date, dataDate: Date) -> DateFilter {
    let myDateNow = MyDate(date: date)
    let sqlDate = MyDate(date: dataDate)
    let minute = 60
    let hour = 60 * minute
    let day = 24 * hour
    let week = 7 * day
    let time = abs(dataDate.timeIntervalSince(date))
    let timeInterval = TimeInterval(week)
    if myDateNow.getDay() == sqlDate.getDay() &&
        myDateNow.getMonth() == sqlDate.getMonth() &&
        myDateNow.getYear() == sqlDate.getYear() &&
        segment == .day {
      dateFilter = .day
    } else if time <= timeInterval && segment == .week {
      dateFilter = .week
    } else if myDateNow.getMonth() == sqlDate.getMonth()
                && myDateNow.getYear() == sqlDate.getYear() &&
                segment == .month {
      dateFilter = .month
    } else if myDateNow.getYear() == sqlDate.getYear() {
      dateFilter = .year
    }
    return dateFilter
  }
}
// MARK: - UITableViewDataSource
extension StatisticViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "WalletCell", for: indexPath) as? WalletCell
    if dropDownisIncome {
        let object = dataIncome[indexPath.row]
        cell?.categoryLabel.text = object.category
        cell?.dateLabel.text = ConfigureManager.configureDate(object.date, dateFormat: "d MMM, YYYY")
        cell?.amountLabel.text = "+ " +  ConfigureManager.configureNumberAsCurrancy(
          object.amount as NSNumber, numberStyle: .currency, currencyCode: "USD")
        cell?.amountLabel.textColor = R.color.green1()
        cell?.isUserInteractionEnabled = false
    } else {
      let object = dataExpense[indexPath.row]
        cell?.categoryLabel.text = object.category
        cell?.dateLabel.text = ConfigureManager.configureDate(object.date, dateFormat: "d MMM, YYYY")
        cell?.amountLabel.text = "- " +  ConfigureManager.configureNumberAsCurrancy(
          object.amount as NSNumber, numberStyle: .currency, currencyCode: "USD")
        cell?.amountLabel.textColor = .red
        cell?.isUserInteractionEnabled = false
      }
    return cell!
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if dropDownisIncome {
      return dataIncome.count
    } else {
      return dataExpense.count
    }
  }
}
