//
//  HistoryViewController.swift
//  ExpenseTracker
//
//  Created by Oleksii Mykhalchuk on 5/6/22.
//

import UIKit

class HomePageViewController: UIViewController {
  @IBOutlet weak var viewTotals: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
      showBackgroundView()
      configureViewTotals()
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
}
