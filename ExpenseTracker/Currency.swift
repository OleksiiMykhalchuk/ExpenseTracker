//
//  Currency.swift
//  ExpenseTracker
//
//  Created by Oleksii Mykhalchuk on 5/23/22.
//

import Foundation

struct Currency {
  static let currency: String = {
    let currency = ["USD", "EUR", "UAH", "HRK"]
    return currency[index]
  }()
  static let index = 0
}
