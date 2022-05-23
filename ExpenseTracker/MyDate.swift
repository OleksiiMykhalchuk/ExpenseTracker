//
//  MyDate.swift
//  ExpenseTracker
//
//  Created by Oleksii Mykhalchuk on 5/17/22.
//

import Foundation

class MyDate {
  private let date: Date
  init(date: Date) {
    self.date = date
  }
  func getDay() -> Int {
    let day = formatter(date, for: "dd")
    return Int(day) ?? 0
  }
  func getMonth() -> Int {
    let month = formatter(date, for: "MM")
    return Int(month) ?? 0
  }
  func getYear() -> Int {
    let year = formatter(date, for: "yyyy")
    return Int(year) ?? 0
  }
  private func formatter(_ date: Date, for format: String) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = format
    let date = formatter.string(from: date)
    return date
  }
}
extension Date {
  func getDay() -> Int{
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
