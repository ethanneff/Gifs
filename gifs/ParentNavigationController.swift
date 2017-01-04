//
//  NavigationViewController.swift
//  tableViewAutoScroll
//
//  Created by Ethan Neff on 8/3/16.
//  Copyright © 2016 Ethan Neff. All rights reserved.
//

import UIKit

class ParentNavigationController: UINavigationController {
    let main = GifsViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pushViewController(main, animated: true)
    }
}
