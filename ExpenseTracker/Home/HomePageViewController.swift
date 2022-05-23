//
//  HistoryViewController.swift
//  ExpenseTracker
//
//  Created by Oleksii Mykhalchuk on 5/6/22.
//

import UIKit


class HomePageViewController: UIViewController {
  // MARK: - Outlets
  @IBOutlet weak var viewTotals: UIView!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var totalLabel: UILabel!
  @IBOutlet weak var incomeLabel: UILabel!
  @IBOutlet weak var expenseLabel: UILabel!
  @IBOutlet weak var seeAllBtn: UIButton!
  @IBOutlet weak var transactionLabel: UILabel!
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
  var constraintTop = NSLayoutConstraint()
  var tableConstraints = NSLayoutConstraint()
  // MARK: - Actions
  @IBAction func seeAll() {
    allView.backgroundColor = .white
    view.addSubview(allView)
    view.bringSubviewToFront(allView)
    allView.translatesAutoresizingMaskIntoConstraints = false
    seeAllAnimation()
    let constraints = [
      allView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      allView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      allView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.size.height / 10),
      allView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -55)
    ]
    NSLayoutConstraint.activate(constraints)

    label.text = R.string.localization.transactionHistory()
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

    tableView.translatesAutoresizingMaskIntoConstraints = false

    constraintTop.isActive = false
    tableConstraints = tableView.topAnchor.constraint(equalTo: allView.topAnchor, constant: 40)
    tableConstraints.isActive = true
  }
  @objc func closePress(_ sender: UIButton) {
    closeAnimate()
    constraintTop.isActive = true
  }
    override func viewDidLoad() {
        super.viewDidLoad()
      tableView.delegate = self
      tableView.dataSource = self
      showBackgroundView()
      configureViewTotals()
      configureTitleTextAttributes()
      totalLabel.text = NumberFormatter.configureNumberAsCurrancy(0.0, numberStyle: .currency, currencyCode: "USD")
      incomeLabel.text = NumberFormatter.configureNumberAsCurrancy(0.0, numberStyle: .currency, currencyCode: "USD")
      expenseLabel.text = NumberFormatter.configureNumberAsCurrancy(0.0, numberStyle: .currency, currencyCode: "USD")
      constraintTop = tableView.topAnchor.constraint(equalTo: transactionLabel.bottomAnchor, constant: 5)
      constraintTop.isActive = true
    }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
    for object in dataBaseManager.getIncomeExpense().1 {
          income = object.amount
        break
    }
    totalIncome = 0.0
    for object in dataBaseManager.getIncomeExpense().1 {
        totalIncome += object.amount
    }
    for object in dataBaseManager.getIncomeExpense().2 {
          expense = object.amount
        break
    }
    totalExpense = 0.0
    for object in dataBaseManager.getIncomeExpense().2 {
        totalExpense += object.amount
    }
    totalBalance = totalIncome - totalExpense
    totalBalance < 0 ? (negative = "- ") : (negative = "")
  }
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if totalBalance != 0.0 {
      NumberLabelAnimate.startAnimate(totalBalance, speed: 2.0) { balance in
      self.totalLabel.text = self.negative + "\(balance)"
      }
    }
    if let income = income {
      NumberLabelAnimate.startAnimate(income, speed: 2.0) { balance in
        self.incomeLabel.text = "\(balance)"
      }
    }
    if let expense = expense {
      NumberLabelAnimate.startAnimate(expense, speed: 2.0) { balance in
        self.expenseLabel.text = "\(balance)"
      }
    }
  }
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    NumberLabelAnimate.stopAnimation()
  }
  // MARK: - Private Methods
  private func seeAllAnimation() {
    label.alpha = 0.0
    closeButton.alpha = 0.0
    allView.alpha = 0.0
    UIView.animate(
      withDuration: 0.4,
      delay: 0.0,
      options: .allowAnimatedContent,
      animations: {self.viewTotals.alpha = 0.0
        self.tableView.alpha = 0.0
      },
      completion: nil)
    UIView.animate(
      withDuration: 0.4,
      delay: 0.4,
      options: .curveEaseIn,
      animations: {
        self.allView.alpha = 1.0
        self.allView.layer.cornerRadius = 20
      },
      completion: nil)
    UIView.animate(
      withDuration: 0.4,
      delay: 0.8,
      options: .curveEaseIn,
      animations: {
        self.label.alpha = 1.0
        self.closeButton.alpha = 1.0
        self.tableView.alpha = 1.0

      },
      completion: nil)
  }
  private func closeAnimate() {
    UIView.animate(
      withDuration: 0.4,
      delay: 0.0,
      options: .curveLinear,
      animations: {
        self.tableConstraints.isActive = false
        self.allView.alpha = 0.0
        self.tableView.alpha = 0.0
        self.label.alpha = 0.0
        self.closeButton.alpha = 0.0
      },
      completion: {    _ in self.allView.removeFromSuperview()
        self.label.removeFromSuperview()
        self.closeButton.removeFromSuperview()
      })
    UIView.animate(
      withDuration: 0.4,
      delay: 0.4,
      options: .curveLinear,
      animations: {self.viewTotals.alpha = 1.0
        self.tableView.alpha = 1.0
      },
      completion: nil)
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
    if dataBaseManager.getIncomeExpense().0.isEmpty {
      cell.categoryLabel.text = "No Records"
      cell.categoryLabel.textColor = .red
      cell.amountLabel.text = ""
      cell.dateLabel.text = ""
      cell.isUserInteractionEnabled = false
      return cell
    } else {
      let object = dataBaseManager.getIncomeExpense().0[indexPath.row]
      var prefix = "- "
      cell.categoryLabel.textColor = R.color.blackWhiteText()
        cell.categoryLabel.text = object.category
        let date = object.date
        cell.dateLabel.text = DateFormatter.stringFrom(date, dateFormat: "d MMM, YYYY")
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
    if dataBaseManager.getIncomeExpense().0.isEmpty {
      return 1
    } else {
      return dataBaseManager.getIncomeExpense().0.count
    }
  }
}
