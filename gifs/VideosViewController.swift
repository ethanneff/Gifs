//
//  TableViewController.swift
//  tableViewAutoScroll
//
//  Created by Ethan Neff on 8/2/16.
//  Copyright © 2016 Ethan Neff. All rights reserved.
//

import UIKit

class VideosViewController: UIViewController {
  let tableView: UITableView = UITableView()
  var items: [Int] = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTableView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupView()
  }
}

// MARK: - view
extension VideosViewController {
  func setupView() {
    tabBarController?.title = "Videos"
    view.backgroundColor = .white
  }
}

// MARK: - tableview
extension VideosViewController: UITableViewDelegate, UITableViewDataSource {
  func setupTableView() {
    view.addSubview(tableView)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(VideosViewControllerCell.self, forCellReuseIdentifier: VideosViewControllerCell.identifier)
    NSLayoutConstraint.activate([
      NSLayoutConstraint(item: tableView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0),
      NSLayoutConstraint(item: tableView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0),
      NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0),
      NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0),
      ])
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: VideosViewControllerCell.identifier, for: indexPath)
    cell.textLabel?.text = String(items[indexPath.row])
    return cell
  }
}
