//
//  HistoryViewController.swift
//  ExpenseTracker
//
//  Created by Oleksii Mykhalchuk on 5/16/22.
//

import UIKit

class StatisticViewController: UIViewController {
  @IBOutlet weak var viewGraph: UIView!
  @IBOutlet weak var tableView: UITableView!
  let label = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
      title = "Statistic"
      viewGraph.layer.borderWidth = 1
      label.text = "Graphs View"
      label.bounds.size = CGSize(width: 100, height: 20)
      label.center = viewGraph.center
      label.layer.borderWidth = 1
      viewGraph.addSubview(label)
    }
}
