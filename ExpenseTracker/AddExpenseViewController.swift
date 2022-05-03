//
//  AddExpenseViewController.swift
//  ExpenseTracker
//
//  Created by Oleksii Mykhalchuk on 5/2/22.
//

import UIKit

class AddExpenseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let nav = self.navigationController?.navigationBar
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let backgroundView = BackgroundView(frame: CGRect.zero)
        backgroundView.backgroundColor = .clear
        backgroundView.frame = view.bounds
        view.addSubview(backgroundView)
    }
}
