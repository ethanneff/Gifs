//
//  AppDelegate.swift
//  gifs
//
//  Created by ethan on 1/3/17.
//  Copyright © 2017 eneff. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    navigateToFirstController(viewController: ParentNavigationController())
    return true
  }
}

