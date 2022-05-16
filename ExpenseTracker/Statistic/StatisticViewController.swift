//
//  HistoryViewController.swift
//  ExpenseTracker
//
//  Created by Oleksii Mykhalchuk on 5/16/22.
//

import UIKit
import CoreData

class StatisticViewController: UIViewController {
  @IBOutlet weak var viewGraph: UIView!
  @IBOutlet weak var tableView: UITableView!
  let label = UILabel()
  var managedObjectContext: NSManagedObjectContext!
    override func viewDidLoad() {
        super.viewDidLoad()
      title = "Statistic"
      viewGraph.layer.borderWidth = 1
      label.text = "Graphs View"
      label.bounds.size = CGSize(width: 100, height: 20)
      label.center = viewGraph.center
      label.layer.borderWidth = 1
      viewGraph.addSubview(label)
      tableView.dataSource = self
      let cellNib = UINib(nibName: "WalletCell", bundle: nil)
      tableView.register(cellNib, forCellReuseIdentifier: "WalletCell")
    }
}
// MARK: - StatisticViewController
extension StatisticViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .default, reuseIdentifier: "WalletCell")
    let cellView = tableView.dequeueReusableCell(withIdentifier: "WalletCell", for: indexPath)
    cell.textLabel?.text = "Label"
    return cellView
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
}
