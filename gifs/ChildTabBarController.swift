//
//  ChildTabBarController.swift
//  GifsVideosScroll
//
//  Created by Ethan Neff on 8/5/16.
//  Copyright © 2016 Ethan Neff. All rights reserved.
//

import UIKit

class ChildTabBarController: UITabBarController {
  let gifsController = GifsViewController()
  let gifsIcon = UITabBarItem(tabBarSystemItem: .featured, tag: 1)
  let videosController = VideosViewController()
  let videosIcon = UITabBarItem(tabBarSystemItem: .more, tag: 2)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTabBar()
  }
  
  fileprivate func setupTabBar() {
    gifsController.tabBarItem = gifsIcon
    videosController.tabBarItem = videosIcon
    viewControllers = [gifsController, videosController]
  }
}
