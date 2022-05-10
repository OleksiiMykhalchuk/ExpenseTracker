//
//  HomeTableViewCell.swift
//  ExpenseTracker
//
//  Created by Oleksii Mykhalchuk on 5/10/22.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var amountLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
