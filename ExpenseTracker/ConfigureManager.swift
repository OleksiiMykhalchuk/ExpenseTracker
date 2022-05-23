//
//  ConfigureManager.swift
//  ExpenseTracker
//
//  Created by Oleksii Mykhalchuk on 5/13/22.
//

import Foundation

class ConfigureManager {
  class func configureDate(_ date: Date, dateFormat: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateFormat
    let dateString = dateFormatter.string(from: date)
    return dateString
  }
 class  func configureNumberAsCurrancy(
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
