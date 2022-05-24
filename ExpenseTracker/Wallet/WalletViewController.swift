//
//  WalletViewController.swift
//  ExpenseTracker
//
//  Created by Oleksii Mykhalchuk on 5/10/22.
//

import UIKit

class WalletViewController: UIViewController {
  @IBOutlet weak var viewContent: UIView!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var totalLabel: UILabel!
  // MARK: - Variables
  var dataBaseManager: DataBaseManager!
  private var totalBalance: Double!
  private var totalIncome: Double!
  private var totalExpense: Double!
  private var negative = ""
  private var valueAnimatorTotalBalance: ValueAnimator?
    override func viewDidLoad() {
        super.viewDidLoad()
      title = R.string.localization.wallet()
      showBackgroundView()
      configureTitleTextAttributes()
      configureViewContent()
      tableView.register(R.nib.walletCell)
      tableView.delegate = self
      tableView.dataSource = self
      totalLabel.text = NumberFormatter.configureNumberAsCurrancy(
        0.0,
        numberStyle: .currency,
        currencyCode: Currency.currency)
    }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    countBalance()
  }
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    animateNumbers()
  }
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    valueAnimatorTotalBalance = nil
  }
  // MARK: - Private Methods
  private func animateNumbers() {
    if totalBalance != 0.0 {
       valueAnimatorTotalBalance = ValueAnimator(
       startValue: 0.0,
       endValue: totalBalance,
       animationDuration: 1.0,
       valueUpdater: { totalBalance in
       self.totalLabel.text = "\(totalBalance)"
       })
     valueAnimatorTotalBalance?.start()
    }
  }
  private func countBalance() {
    totalIncome = 0.0
    for object in dataBaseManager.getIncomeExpense().1 {
      totalIncome += object.amount
    }
    totalExpense = 0.0
    for object in dataBaseManager.getIncomeExpense().2 {
      totalExpense += object.amount
    }
    totalBalance = totalIncome - totalExpense
    if totalBalance < 0 { negative = "- "} else { negative = ""
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
  private func configureViewContent() {
    viewContent.layer.cornerRadius = 30
  }
  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "AddIncome" {
      guard let controller = segue.destination as? AddIncomeViewController else { return }
      controller.dataBaseManager = dataBaseManager
      controller.delegate = self
      NumberLabelAnimate.stopAnimation()
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
    guard let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.walletCell,
      for: indexPath) else { return UITableViewCell() }
    if dataBaseManager.getIncomeExpense().1.isEmpty {
      cell.amountLabel.text = ""
      cell.categoryLabel.text = R.string.localization.noRecords()
      cell.categoryLabel.textColor = .red
      cell.dateLabel.text = ""
      cell.isUserInteractionEnabled = false
    } else {
      let object = dataBaseManager.getIncomeExpense().1[indexPath.row]
      cell.categoryLabel.textColor = R.color.blackWhiteText()
        let date = object.date
        let amount = NSNumber(value: object.amount)
        let category = object.category
        cell.dateLabel.text = DateFormatter.stringFrom(date, dateFormat: "d MMM, YYYY")
        cell.categoryLabel.text = category
        cell.amountLabel.text = NumberFormatter.configureNumberAsCurrancy(
          amount,
          numberStyle: .currency,
          currencyCode: Currency.currency)
    }
    cell.isUserInteractionEnabled = false
    return cell
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if dataBaseManager.getIncomeExpense().1.isEmpty {
      return 1
    } else {
      return dataBaseManager.getIncomeExpense().1.count
    }
  }
}
// MARK: - AddIncomeViewControllerDelegate
extension WalletViewController: AddIncomeViewControllerDelegate {
  func addIncomeViewControllerDidReloadOnDismiss() {
    animateNumbers()
  }
  func reloadOnDone() {
    countBalance()
  }
}
