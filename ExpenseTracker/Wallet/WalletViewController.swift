//
//  WalletViewController.swift
//  ExpenseTracker
//
//  Created by Oleksii Mykhalchuk on 5/10/22.
//

import UIKit

class WalletViewController: UIViewController {
  @IBOutlet weak var viewContent: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
      title = "Wallet"
      showBackgroundView()
      configureTitleTextAttributes()
      configureViewContent()
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
}
