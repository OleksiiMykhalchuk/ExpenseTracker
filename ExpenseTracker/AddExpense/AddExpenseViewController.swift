//
//  AddExpenseViewController.swift
//  ExpenseTracker
//
//  Created by Oleksii Mykhalchuk on 5/2/22.
//

import UIKit
import CoreData

class AddExpenseViewController: UIViewController {
  @IBOutlet weak var contentView: UIView!
  var contentTableView: AddExpenseContentViewController?
  var dataBaseManager: DataBaseManager!

  override func viewDidLoad() {
    super.viewDidLoad()
    configureContentView()
    configureTitleTextAttributes()
    showBackgroundView()
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
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let controller  = segue.destination as? AddExpenseContentViewController, segue.identifier == "EmbedSegue" {
      controller.dataBaseManager = dataBaseManager
    }
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
