//
//  MyDate.swift
//  ExpenseTracker
//
//  Created by Oleksii Mykhalchuk on 5/17/22.
//

import Foundation

extension Date {
  func getDay() -> Int {
    let day = DateFormatter.stringFrom(self, dateFormat: "dd")
    return Int(day) ?? 0
  }
  func getMonth() -> Int {
    let month = DateFormatter.stringFrom(self, dateFormat: "MM")
    return Int(month) ?? 0
  }
  func getYear() -> Int {
    let year = DateFormatter.stringFrom(self, dateFormat: "yyyy")
    return Int(year) ?? 0
  }
}
