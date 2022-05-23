//
//  NumberFormatter extension.swift
//  ExpenseTracker
//
//  Created by Oleksii Mykhalchuk on 5/23/22.
//

import Foundation

extension NumberFormatter {
  static func configureNumberAsCurrancy(
    _ number: NSNumber,
    numberStyle: NumberFormatter.Style,
    currencyCode: String) -> String {
      let formatter = NumberFormatter()
      formatter.numberStyle = numberStyle
      formatter.currencyCode = currencyCode
      let numberString = formatter.string(from: number)
      return numberString!
  }
}
