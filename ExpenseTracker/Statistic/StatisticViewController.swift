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
        getData()
        tableView.reloadData()
    case 1:
        segment = .week
        getData()
        tableView.reloadData()
    case 2:
        segment = .month
        getData()
        tableView.reloadData()
    case 3:
        segment = .year
        getData()
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
  var dataBaseManager: DataBaseManager!
  var dataIncome = [IncomeExpenseEntity]()
  var dataExpense = [IncomeExpenseEntity]()
  let now = Date()
    override func viewDidLoad() {
        super.viewDidLoad()

        title = R.string.localization.statistic()
      tableView.dataSource = self
        tableView.register(R.nib.walletCell)
      tableView.rowHeight = 60
        dropDown.optionArray = [R.string.localization.income(), R.string.localization.expense()]
      dropDown.optionIds = [0, 1]
      dropDown.selectedRowColor = R.color.green2()!
      dropDown.checkMarkEnabled = false
      dropDown.selectedIndex = 0
      dropDown.isSearchEnable = false
      dropDown.text = R.string.localization.income()
      dropDown.didSelect(completion: {_, index, _ in
        if index == 0 {
          self.dropDownisIncome = true
          self.tableView.reloadData()
          self.getData()
        } else {
          self.dropDownisIncome = false
          self.tableView.reloadData()
          self.getData()
        }
      })
    }
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    getData()
    tableView.reloadData()
  }
  func getData() {
    dataIncome.removeAll()
    dataExpense.removeAll()
    let getIncomeSorted = dataBaseManager.getIncomeExpense().1.sorted(by: {lhs, rhs in
      return lhs.amount > rhs.amount
    })
    let getExpenseSorted = dataBaseManager.getIncomeExpense().2.sorted(by: { lhs, rhs in
      return lhs.amount > rhs.amount
    })
    for income in getIncomeSorted
    where segment.rawValue == filterByDate(now: Date(), dataDate: income.date).rawValue {
        dataIncome.append(income)
    }
    for expense in getExpenseSorted
    where segment.rawValue == filterByDate(now: Date(), dataDate: expense.date).rawValue {
      dataExpense.append(expense)
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
      let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.walletCell, for: indexPath)
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
