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
    let cell = tableView.dequeueReusableCell(
      withIdentifier: "WalletCell",
      for: indexPath)
    cell.isUserInteractionEnabled = false
    return cell
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }
}
