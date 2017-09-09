//
//  TrucksTableViewController.swift
//  yum
//
//  Created by Keaton Burleson on 9/9/17.
//  Copyright © 2017 poeen. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class TrucksTableViewController: UIViewController {
    private(set) public var truckHelper = TruckHelper()
    public var trucks: [Truck] = []

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var gripperView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        gripperView.layer.cornerRadius = 2.5
        truckHelper.getTrucks { (trucks) in
            self.trucks = trucks
            self.tableView.reloadData()
        }
    }


}
extension TrucksTableViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.trucks.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "truckCell")
        cell?.textLabel?.text = trucks[indexPath.row].name
        return cell!
    }
}
