//
//  SceneDelegate.swift
//  ExpenseTracker
//
//  Created by Oleksii Mykhalchuk on 4/29/22.
//

import UIKit
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?
  private let applicationDocumentsDirectory: URL = {
    let paths = FileManager.default.urls(
      for: .documentDirectory,
      in: .userDomainMask)
    return paths[0]
  }()
    private var dataBaseManager = DataBaseManager()
  func scene(_ scene: UIScene,
             willConnectTo session: UISceneSession,
             options connectionOptions: UIScene.ConnectionOptions) {
    window?.tintColor = R.color.green2()
    let tabController = window?.rootViewController as? UITabBarController
    if let tabViewControllers = tabController?.viewControllers {
      // First Tab
      var navController = tabViewControllers[0] as? UINavigationController
      let controller1 = navController?.viewControllers.first as? HomePageViewController
      controller1?.dataBaseManager = dataBaseManager
      // Second Tab
      navController = tabViewControllers[1] as? UINavigationController
      let controller2 = navController?.viewControllers.first as? StatisticViewController
      controller2?.dataBaseManager = dataBaseManager
      // Third Tab
      navController = tabViewControllers[2] as? UINavigationController
      let controller3 = navController?.viewControllers.first as? WalletViewController
      controller3?.dataBaseManager = dataBaseManager
      // Fours Tab
      navController = tabViewControllers[3] as? UINavigationController
      let controller4 = navController?.viewControllers.first as? AddExpenseViewController
      controller4?.dataBaseManager = dataBaseManager

    } else {
      AlertManager.alertOnError(message: "tableView Controllers is nil")
    }
    print(applicationDocumentsDirectory)
    // Use this method to optionally configure
    // and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property
    // will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting
    // scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    guard let _ = (scene as? UIWindowScene) else { return }
  }
  func sceneDidDisconnect(_ scene: UIScene) {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session
    // was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
  }
  func sceneDidBecomeActive(_ scene: UIScene) {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
  }
  func sceneWillResignActive(_ scene: UIScene) {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
  }
  func sceneWillEnterForeground(_ scene: UIScene) {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
  }
  func sceneDidEnterBackground(_ scene: UIScene) {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
    // Save changes in the application's managed object context when the application transitions to the background.
      dataBaseManager.save()
  }
}
