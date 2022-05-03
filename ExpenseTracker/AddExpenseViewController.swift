//
//  AddExpenseViewController.swift
//  ExpenseTracker
//
//  Created by Oleksii Mykhalchuk on 5/2/22.
//

import UIKit

class AddExpenseViewController: UIViewController {
    @IBOutlet weak var contentView: UITableView!
    var contentTableView: AddExpenseContentViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.backgroundColor = .white
        contentView.clipsToBounds = false
        contentView.layer.masksToBounds = false
        contentView.layer.shadowColor = UIColor.lightGray.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
        contentView.layer.shadowRadius = 5.0
        contentView.layer.shadowOpacity = 0.5
        contentView.layer.cornerRadius = 20
        contentView.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        self.contentView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        contentView.delegate = self
        contentView.dataSource = self
//        showContent()
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
        view.sendSubviewToBack(backgroundView)
    }
    func showContent() {
        contentTableView = storyboard!.instantiateViewController(
            withIdentifier: "ContentTable") as? AddExpenseContentViewController
        if let controller = contentTableView {
            controller.view.frame = contentView.frame
            view.addSubview(controller.view)
            addChild(controller)
        }
    }
}

extension AddExpenseViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberOfRows")
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel!.text = "Label"
        print("cellForRowAt")
        return cell
    }
}
