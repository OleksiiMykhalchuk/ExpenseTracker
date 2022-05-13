//
//  WalletCell.swift
//  ExpenseTracker
//
//  Created by Oleksii Mykhalchuk on 5/12/22.
//

import UIKit

class WalletCell: UITableViewCell {
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
