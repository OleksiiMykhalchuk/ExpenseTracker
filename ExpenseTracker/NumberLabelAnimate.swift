//
//  NumberLabelAnimate.swift
//  ExpenseTracker
//
//  Created by Oleksii Mykhalchuk on 5/20/22.
//

import Foundation

class NumberLabelAnimate {
  private static var workItem: DispatchWorkItem?
  private static var thread: DispatchWorkItem?
  private static var isCancel = false
  static func startAnimate(_ number: Double, speed: Double, completion: @escaping (String) -> Void) {
    let total = abs(Int(number))
    let duration = speed
    self.isCancel = false
    DispatchQueue.global().async {
      for number in 0...abs(total) {
        let sleepTime = Int32(duration/Double(total) * 1000000.0)
        usleep(useconds_t(sleepTime))
        let balance = NumberFormatter.configureNumberAsCurrancy(
          number as NSNumber,
          numberStyle: .currency,
          currencyCode: "USD")
        DispatchQueue.main.async {
          completion(balance)
          if self.isCancel {
            Thread.current.cancel() // not sure if it is good for something
          }
        }
        if self.isCancel {
          Thread.current.cancel() // not sure if it is good for something
          break
        }
      }
    }
  }
  static func stopAnimation() {
    isCancel = true
  }
}
