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
  static func startAnimate(_ number: Double, speed: Double, completion: @escaping (String) -> Void) {
    let total = abs(Int(number))
    let duration = speed
    workItem = DispatchWorkItem {
      for number in 0...abs(total) {
        let sleepTime = Int32(duration/Double(total) * 1000000.0)
        usleep(useconds_t(sleepTime))
        let balance = ConfigureManager.configureNumberAsCurrancy(
          number as NSNumber,
          numberStyle: .currency,
          currencyCode: "USD")
        DispatchQueue.main.async {
          completion(balance)
        }
      }
    }
    DispatchQueue.global().async(execute: workItem!)
  }
  static func stopAnimation() {
    workItem?.cancel()
  }
}
