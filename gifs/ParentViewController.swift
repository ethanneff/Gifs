//
//  ParentViewController.swift
//  tableViewAutoScroll
//
//  Created by Ethan Neff on 8/3/16.
//  Copyright © 2016 Ethan Neff. All rights reserved.
//

import UIKit

class ParentViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "parent"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(right))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    fileprivate dynamic func right() {
        navigationController?.pushViewController(GifsViewController(), animated: true)
    }
}
