//
//  DateFormatter Extension.swift
//  ExpenseTracker
//
//  Created by Oleksii Mykhalchuk on 5/23/22.
//

import Foundation

extension DateFormatter {
  static func stringFrom(_ date: Date, dateFormat: String) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = dateFormat
    let dateString = formatter.string(from: date)
    return dateString
  }
}
