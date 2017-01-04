//
//  NavigateToFirstViewController.swift
//  gifs
//
//  Created by ethan on 1/3/17.
//  Copyright © 2017 eneff. All rights reserved.
//

import UIKit

extension AppDelegate {
  func navigateToFirstController(viewController: UIViewController) {
    window = UIWindow(frame: UIScreen.main.bounds)
    guard let window = window else { return }
    window.rootViewController = viewController
    window.makeKeyAndVisible()
  }
}
