//
//  ViewController.swift
//  ExpenseTracker
//
//  Created by Oleksii Mykhalchuk on 4/29/22.
//

import UIKit

class TabViewController: UITabBarController {
  override func viewDidLoad() {
    super.viewDidLoad()
    self.delegate = self
    print("*** TabViewController")
  }
}
extension TabViewController: UITabBarControllerDelegate {
  public func tabBarController(
    _ tabBarController: UITabBarController,
    shouldSelect viewController: UIViewController) -> Bool {
    print("\n*** tab bar should select\n")
      let fromView = tabBarController.selectedViewController?.view
      let toView = viewController.view
      if fromView == toView {
        return false
      }
      UIView.transition(
        from: fromView!,
        to: toView!,
        duration: 0.6,
        options: UIView.AnimationOptions.transitionCrossDissolve,
        completion: nil)
    return true
  }
}
