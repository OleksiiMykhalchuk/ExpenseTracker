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
  var managedObjectContext: NSManagedObjectContext!

  override func viewDidLoad() {
    super.viewDidLoad()
    contentView.backgroundColor = UIColor(named: "whiteDarkBackground")
    contentView.clipsToBounds = false
    contentView.layer.masksToBounds = false
    contentView.layer.shadowColor = UIColor.lightGray.cgColor
    contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
    contentView.layer.shadowRadius = 15.0
    contentView.layer.shadowOpacity = 1.0
    contentView.layer.cornerRadius = 20
    showBackgroundView()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
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
      controller.managedObjectContext = managedObjectContext
    }
  }
}
