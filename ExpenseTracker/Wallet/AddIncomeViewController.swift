//
//  AddIncomeViewController.swift
//  ExpenseTracker
//
//  Created by Oleksii Mykhalchuk on 5/12/22.
//

import UIKit

class AddIncomeViewController: UIViewController {
  @IBOutlet weak var contentView: UIView!
  @IBOutlet weak var tableView: UITableView!
  @IBAction func close() {
    dismiss(animated: true)
  }
    override func viewDidLoad() {
        super.viewDidLoad()
      configureContentView()
    }
  // MARK: - Helper Methods
  private func configureContentView() {
    contentView.backgroundColor = R.color.whiteDarkBackground()
    contentView.clipsToBounds = false
    contentView.layer.masksToBounds = false
    contentView.layer.shadowColor = UIColor.lightGray.cgColor
    contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
    contentView.layer.shadowRadius = 15.0
    contentView.layer.shadowOpacity = 1.0
    contentView.layer.cornerRadius = 20
  }
}
