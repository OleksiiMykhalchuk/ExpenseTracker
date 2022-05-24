//
//  ValueAnimator.swift
//  ExpenseTracker
//
//  Created by Oleksii Mykhalchuk on 5/24/22.
//

import Foundation
import QuartzCore

class ValueAnimator {
  private var startValue: Double
  private var endValue: Double
  private var animationDuration: TimeInterval
  private var animationStartDate: Date?
  private var displayLink: CADisplayLink?
  private var valueUpdater: (String) -> Void
  init(
    startValue: Double,
    endValue: Double,
    animationDuration: TimeInterval,
    valueUpdater: @escaping (String) -> Void) {
    self.startValue = startValue
    self.endValue = endValue
    self.animationDuration = animationDuration
    self.valueUpdater = valueUpdater
    self.displayLink = nil
  }
  deinit {
    cancel()
  }
  func start() {
    animationStartDate = Date()
    displayLink = CADisplayLink(target: self, selector: #selector(update))
    displayLink?.add(to: .current, forMode: .default)
  }
  @objc func update() {
    let now = Date()
    let elapsedTime = now.timeIntervalSince(animationStartDate!)
    if elapsedTime > animationDuration {
      valueUpdater(NumberFormatter.configureNumberAsCurrancy(
        endValue as NSNumber,
        numberStyle: .currency,
        currencyCode: Currency.currency))
    } else {
      let persantage = elapsedTime / animationDuration
      let value = persantage * (endValue - startValue)
      valueUpdater(NumberFormatter.configureNumberAsCurrancy(
        value as NSNumber,
        numberStyle: .currency,
        currencyCode: Currency.currency))
    }
  }
  private func cancel() {
    displayLink?.remove(from: .current, forMode: .default)
    displayLink?.invalidate()
    displayLink = nil
  }
}
